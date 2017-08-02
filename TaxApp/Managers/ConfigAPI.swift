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
    static var loginStr = "/login"
    static var signUpStr = "/login/signup"
    
    
    static func loginURL() -> URL {
        return URL(string: serverAPI.appending(loginStr))!
    }

    static func signUpURL() -> URL {
        return URL(string: serverAPI.appending(signUpStr))!
    }

    
 }

