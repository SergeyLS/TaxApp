//
//  ConfigAPI.swift
//  SwotseAPI
//
//  Created by Sergey Leskov on 6/1/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation

class ConfigAPI {
    
    static var serverAPI = "http://185.79.244.158/taxapp/api"
   
    static var loginString = "/login"
    static var signUpString = "/login/signup"
    
    static var getUserString = "/user"
    static var getUserAvatarString = "/user/avatar"
    
    static var getMenuString = "/menu"
    
    //login
    static func loginURL() -> URL {
        return URL(string: serverAPI.appending(loginString))!
    }
    static func signUpURL() -> URL {
        return URL(string: serverAPI.appending(signUpString))!
    }

    //user
    static func getUserURL() -> URL {
        return URL(string: serverAPI.appending(getUserString))!
    }
    static func getUserAvatarURL() -> URL {
        return URL(string: serverAPI.appending(getUserAvatarString))!
    }
    
    //menu
    static func getMenuURL() -> URL {
        return URL(string: serverAPI.appending(getMenuString))!
    }


 }

