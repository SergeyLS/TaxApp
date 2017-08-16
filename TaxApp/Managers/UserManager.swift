//
//  UserManager.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/5/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class UserManager {
    
    
    //getMenuByID
    static func getUserByLogin(login: String,
                               context: NSManagedObjectContext = CoreDataManager.shared.viewContext) -> User? {
        
        if  login == "" { return nil }
        
        let request = NSFetchRequest<User>(entityName: User.type)
        let predicate = NSPredicate(format: "userName == %@", login)
        request.predicate = predicate
        
        let resultsArray = (try? context.fetch(request))
        
        return resultsArray?.first ?? nil
    }

    
    //get user
    static func getUserFromAPI(token: String, completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer "+token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let req = request(ConfigAPI.getUserURL(), method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error! as? String)
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            if (Array(responseJSON.keys).contains("username")) == true {
                
                let userName = responseJSON["username"] as? String ?? ""
                let firstName = responseJSON["first_name"] as? String ?? ""
                let middleName = responseJSON["middle_name"] as? String ?? ""
                let lastName = responseJSON["last_name"] as? String ?? ""
                let eMail = responseJSON["email"] as? String ?? ""
                
                AppDataManager.shared.userLogin = userName
                
                if let user = User(userName: userName) {
                    user.firstName = firstName
                    user.middleName = middleName
                    user.lastName = lastName
                    user.eMail = eMail
                    user.lastLogin = Date()
                    
                    CoreDataManager.shared.saveContext()
                    
                    completion(nil)
                    return
                }
                
                
                
                
            }
            
            completion("Invalid func getUserFromAPI")
            
        }
    }
    
    
    //get getUserAvatarFromAPI
    static func getUserAvatarFromAPI(token: String, completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer "+token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let req = request(ConfigAPI.getUserAvatarURL(), method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseData { response in
            if response.result.isFailure  {
                completion(response.result.error! as? String)
                return
            }
            
            if let user = AppDataManager.shared.currentUser {
                user.photo = response.result.value
                CoreDataManager.shared.saveContext()
                completion(nil)
            }
            
            completion("Invalid func getUserAvatarFromAPI")
        }
        
    }
    
    
    static func messageNoLogin(view: UIView) {
        let title = NSLocalizedString("Нужна авторизация!", comment: "messageNoLogin")
        let message = NSLocalizedString("Тольк для зарегистрированных пользователей!", comment: "messageNoLogin")
        
        MessagerManager.showMessage(title: title, message: message, theme: .warning, view: view)
        
    }
    
}
