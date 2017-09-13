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
                completion(response.result.error?.localizedDescription)
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
                let category_id = responseJSON["category_id"] as? Int ?? 0
                
                AppDataManager.shared.userLogin = userName
                
                if UserManager.getUserByLogin(login: userName) != nil {
                    completion(nil)
                    return
                }
                
                if let user = User(userName: userName) {
                    user.firstName = firstName
                    user.middleName = middleName
                    user.lastName = lastName
                    user.eMail = eMail
                    user.lastLogin = Date()
                    user.category = CategoryManager.getCategoryByID(id: category_id)
                    
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
                completion(response.result.error?.localizedDescription)
                return
            }
            
            if let user = AppDataManager.shared.currentUser {
                user.photo = response.result.value
                CoreDataManager.shared.saveContext()
                completion(nil)
                return
            }
            
            completion("Invalid func getUserAvatarFromAPI")
        }
        
    }
    
    
    //messageNoLogin
    static func messageNoLogin(view: UIView) {
        let title = NSLocalizedString("Нужна авторизация!", comment: "messageNoLogin")
        let message = NSLocalizedString("Только для авторизованных пользователей!", comment: "messageNoLogin")
        
        MessagerManager.showMessage(title: title, message: message, theme: .warning, view: view)
        
    }
    
    
    //patchUserAPI
    static func postUserPhotoAPI(firstName: String,
                                 lastName: String,
                                 category: Category,
                                 completion: @escaping (_ error: String?) -> Void)  {
        
        let token = AppDataManager.shared.userToken
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer "+token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let  parameters = [
            "first_name"  : firstName,
            "last_name"   : lastName,
            "category_id" : category.id
            ] as [String : Any]
        
        
        let req = request(ConfigAPI.getUserURL(), method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error?.localizedDescription)
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            if (responseJSON.keys).contains("username") == true {
                completion(nil)
                return
            }
            
            
            completion("Invalid func patchUserAPI")
        }
    }
    
    
    
    
    //patchUserAPI
    static func patchUserAPI(firstName: String,
                             lastName: String,
                             category: Category,
                             completion: @escaping (_ error: String?) -> Void)  {
        
        let token = AppDataManager.shared.userToken
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer "+token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let  parameters = [
            "first_name"  : firstName,
            "last_name"   : lastName,
            "category_id" : category.id
            ] as [String : Any]
        
        
        let req = request(ConfigAPI.getUserURL(), method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error?.localizedDescription)
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            if (responseJSON.keys).contains("username") == true {
                completion(nil)
                return
            }
            
            
            completion("Invalid func patchUserAPI")
        }
    }
    
    
    //patchChangeUserPassword
    static func patchUserPasswordAPI(password: String,completion: @escaping (_ error: String?) -> Void)  {
        
        let token = AppDataManager.shared.userToken
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer "+token,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let  parameters = [
            "password"  : password,
            ] as [String : Any]
        
        
        let req = request(ConfigAPI.getUserURL(), method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error?.localizedDescription)
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            if (responseJSON.keys).contains("username") == true {
                completion(nil)
                return
            }
            
            
            completion("Invalid func patchUserAPI")
        }
    }
    
    
    
    //postUserPhotoAPI
    static func postUserPhotoAPI(userName: String,
                                 photoImage: UIImage,
                                 completion: @escaping (_ error: String?) -> Void)  {
        
        let token = AppDataManager.shared.userToken
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer "+token,
            "enctype": "multipart/form-data",
            "cache-control": "no-cache"
        ]
        
        let fotoResize = ImageManager.resizeImage(image: photoImage, newWidth: 300)
        //let dataImage = ImageManager.imageToDataAndResize(image: photoImage, newWidth: 300)
        let file = ImageManager.temporaryPhotoURL(name: userName, photoImage: fotoResize)
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(file, withName: "image")
        },
                         to: ConfigAPI.serverAPI.appending(ConfigAPI.getUserAvatarString),
                         method:.post,
                         headers: headers,
                         
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                //responseData
                                upload.responseData { response in
                                    if response.result.isFailure  {
                                        completion(response.result.error?.localizedDescription)
                                        return
                                    }
                                    
                                    //                                    if let user = AppDataManager.shared.currentUser {
                                    //                                        user.photo = dataImage
                                    //                                        CoreDataManager.shared.saveContext()
                                    //                                        completion(nil)
                                    //                                        return
                                    //                                    }
                                    
                                    completion(nil)
                                    
                                }
                                
                            case .failure(let encodingError):
                                completion(encodingError.localizedDescription)
                                return
                            }
        })
        
    }
    
    
}
