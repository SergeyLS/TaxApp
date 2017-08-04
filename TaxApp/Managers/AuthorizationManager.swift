//
//  AuthorizationManager.swift
//  SwotseAPI
//
//  Created by Sergey Leskov on 6/1/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import Alamofire

class AuthorizationManager {
    
    
    //login
    static func login(eMailOrLogin: String, password: String, completion: @escaping (_ error: String?) -> Void)  {
        
        var eMail = ""
        var login = ""
        
        if eMailOrLogin.range(of: "@") == nil {
            login = eMailOrLogin
        } else {
            eMail = eMailOrLogin
        }
        
        let  parameters = [
            "username"  : login,
            "email"     : eMail,
            "password"  : password
        ]
        
        
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let req = request(ConfigAPI.loginURL(), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error! as? String)
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            if (Array(responseJSON.keys).contains("message")) == true {
                if let errors = responseJSON["message"] as? [String: Any] {
                    var str = ""
                    for err in errors {
                        // str += err.key + ": "
                        if let messages = err.value as? [String] {
                            for message in messages {
                                str += message
                            }
                        }
                        
                        str += "\n"
                    }
                    
                    print(str)
                    completion(str)
                }
                
                
                return
            }
            
            if (Array(responseJSON.keys).contains("User")) == true {
                if let users = responseJSON["User"] as? [String: Any] {
                    for tempUser in users {
                        if tempUser.key == "auth_key" {
                            AppDataManager.shared.userName = login
                            AppDataManager.shared.userToken = String(describing: tempUser.value)
                            print("User token: \(String(describing: AppDataManager.shared.userToken))")
                            completion(nil)
                            return
                        }
                    }
                }
            }
            
            
            completion("Error")
            
        }
    }

    
    //registration
    static func registration(eMail: String, login: String, password: String, completion: @escaping (_ error: String?) -> Void)  {
        
       let  parameters = [
            "username"  : login,
            "email"     : eMail,
            "password"  : password
        ]
        
        
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let req = request(ConfigAPI.signUpURL(), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error! as? String)
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            if (Array(responseJSON.keys).contains("message")) == true {
                if let errors = responseJSON["message"] as? [String: Any] {
                    var str = ""
                    for err in errors {
                       // str += err.key + ": "
                        if let messages = err.value as? [String] {
                            for message in messages {
                                str += message
                            }
                         }
                        
                        str += "\n"
                    }
                    
                    print(str)
                    completion(str)
                }
                
 
                return
            }
            
            if (Array(responseJSON.keys).contains("auth_key")) == true {
                AppDataManager.shared.userName = login
                AppDataManager.shared.userToken = responseJSON["auth_key"] as? String
                print("User token: \(String(describing: AppDataManager.shared.userToken))")
                completion(nil)
                return
            }
            
            
            completion("Error")
            
        }
    }
    
    
    
}



