//
//  MessageManager.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/28/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData
import Alamofire


class MessageManager {
    
    //getMessageByID
    static func getMessageByID(id: Int64) -> Message? {
        
        if  id == 0 { return nil }
        
        if AppDataManager.shared.currentUser == nil {
            return nil
        }
        
        let request = NSFetchRequest<Message>(entityName: Message.type)
        
        var arrayPredicate:[NSPredicate] = []
        arrayPredicate.append(NSPredicate(format: "user = %@", AppDataManager.shared.currentUser!))
        arrayPredicate.append(NSPredicate(format: "id = %i", id))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
        request.predicate = predicate
        
        let resultsArray = (try? CoreDataManager.shared.viewContext.fetch(request))
        
        return resultsArray?.first ?? nil
    }
    
    
    //getArticleFromAPI
    static func getMessageFromAPI(messageKind: MessageKind, completion: @escaping (_ error: String?) -> Void)  {
        let token = AppDataManager.shared.userToken
        let headers: HTTPHeaders = [
            "authorization": "Bearer "+token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        var url: URL!
        switch messageKind {
        case .inbox:
            url = ConfigAPI.getMessageInboxURL()
        case .sent:
            url = ConfigAPI.getMessageSentURL()
        default:
            return
        }
        
        let req = request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error?.localizedDescription)
                return
            }
            
            guard let array = response.result.value as? [Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            if array.count == 0 {
                completion(nil)
                return
            }
            
            var isErrors = false
            
            let moc = CoreDataManager.shared.newBackgroundContext
            moc.performAndWait{
                for element in array {
                    if let tempElement = element as? [String: Any] {
                        guard
                            let id = tempElement["id"] as? Int64
                            else {
                                print("error - no id")
                                isErrors = true
                                continue
                        }
                        
                        if let message = getMessageByID(id: id)  {
                            message.update(dictionary: tempElement as NSDictionary, messageKind: messageKind)
                        } else {
                            // New
                            if AppDataManager.shared.currentUser == nil {
                                continue
                            }
                            
                            guard let message = Message(dictionary: tempElement as NSDictionary, messageKind: messageKind, context: moc)   else {
                                print("Error: Could not create a new Message from API.")
                                isErrors = true
                                continue
                            }
                            message.update(dictionary: tempElement as NSDictionary, messageKind: messageKind)
                        } //else
                    }
                }
                CoreDataManager.shared.save(context: moc)
            }
            
            if isErrors == false {
                completion(nil)
                return
            }
            
            completion("Invalid func getMessageFromAPI")
            
        }
    }
    
    
    
    //sendMail
    static func sendMessage(replyMessage: Message?, text: String, completion: @escaping (_ error: String?, _ message: Message?) -> Void)  {
        let token = AppDataManager.shared.userToken
        
        var parameters = [String : Any]()
        parameters.updateValue(text, forKey: "body")
        if let message = replyMessage  {
            parameters.updateValue(message.id, forKey: "reply_id")
        }
        
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer " + token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let req = request(ConfigAPI.getMessageURL(), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error?.localizedDescription, nil)
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion("Invalid tag information received from service", nil)
                return
            }
            
            
            if (Array(responseJSON.keys).contains("message")) == true {
                if let errors = responseJSON["message"] as? String {
                    completion(errors, nil)
                    return
                }
            }
            
            if (Array(responseJSON.keys).contains("user_read_at")) == true {
                
                guard let message = Message(dictionary: responseJSON as NSDictionary, messageKind: .sent)   else {
                    completion("Error: Could not create a new Message from API.", nil)
                    return
                }
                message.update(dictionary: responseJSON as NSDictionary, messageKind: .sent)
                CoreDataManager.shared.saveContext()
                
                completion(nil, message)
                return
            }
            
            
            
            completion("Error Send Message", nil)
            
        }
    }
    
    
    static func setMainID()  {
        
        var resultsArray = [Message]()
        
        let request = NSFetchRequest<Message>(entityName: Message.type)
        
        var arrayPredicate:[NSPredicate] = []
        arrayPredicate.append(NSPredicate(format: "user = %@", AppDataManager.shared.currentUser!))
        arrayPredicate.append(NSPredicate(format: "mainID = %i", 0))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
        request.predicate = predicate
        
        resultsArray = (try? CoreDataManager.shared.viewContext.fetch(request)) ?? []
        
        if resultsArray.count == 0 {
            return
        }
        
        for message in resultsArray {
            if message.replyID == 0  {
                message.mainID = message.id
            } else {
                if let replyMessage = getMessageByID(id: message.replyID) {
                    if replyMessage.mainID == 0 {
                        message.mainID = replyMessage.id
                    } else {
                        message.mainID = replyMessage.mainID
                    }
                } else {
                    message.mainID = message.id
                }
            }
        }
        CoreDataManager.shared.saveContext()
        
    }
    
}
