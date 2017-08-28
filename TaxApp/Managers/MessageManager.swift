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
    static func getMessageByID(id: Int) -> Message? {
        
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
                            let id = tempElement["id"] as? Int
                            else {
                                print("error - no id")
                                isErrors = true
                                continue
                        }
                        
                        if let message = getMessageByID(id: id )  {
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

}
