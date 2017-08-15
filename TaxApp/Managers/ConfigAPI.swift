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
    static var loginSocialString = "/login/by-key"
    static var signUpString = "/login/signup"
    static var resetString = "/login/reset"
    
    static var getUserString = "/user"
    static var getUserAvatarString = "/user/avatar"
    
    static var getMenuString = "/menu"
    
    static var getArticleString = "/article/section/"
    static var getNewsString = "/news"
    static var getArticleLikeString = "/article/like/"
    static var getArticleSearchString = "/article/search/"
    
    //login
    static func loginURL() -> URL {
        return URL(string: serverAPI.appending(loginString))!
    }
    static func loginSocial() -> URL {
        return URL(string: serverAPI.appending(loginSocialString))!
    }
    static func signUpURL() -> URL {
        return URL(string: serverAPI.appending(signUpString))!
    }
    static func resetURL() -> URL {
        return URL(string: serverAPI.appending(resetString))!
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

    //news
    static func getNewsURL() -> URL {
        return URL(string: serverAPI.appending(getNewsString))!
    }


 }

