//
//  ConfigAPI.swift
//  SwotseAPI
//
//  Created by Sergey Leskov on 6/1/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation

class ConfigAPI {
    
    static var server = "http://185.79.244.158"
    static var serverAPI = server + "/taxapp/api"
    
    //login
    static func loginURL() -> URL {
        let loginString = "/login"
        return URL(string: serverAPI.appending(loginString))!
    }
    static func loginSocial() -> URL {
        let loginSocialString = "/login/by-key"
        return URL(string: serverAPI.appending(loginSocialString))!
    }
    static func signUpURL() -> URL {
        let signUpString = "/login/signup"
        return URL(string: serverAPI.appending(signUpString))!
    }
    static func resetURL() -> URL {
        let resetString = "/login/reset"
        return URL(string: serverAPI.appending(resetString))!
    }
    
    //user
    static var getUserAvatarString = "/user/avatar"
    
    static func getUserURL() -> URL {
        let getUserString = "/user"
        return URL(string: serverAPI.appending(getUserString))!
    }
    static func getUserAvatarURL() -> URL {
        return URL(string: serverAPI.appending(getUserAvatarString))!
    }
    
    //menu
    static func getMenuURL() -> URL {
        let getMenuString = "/menu"
        return URL(string: serverAPI.appending(getMenuString))!
    }
    static func getMenuEnglishURL() -> URL {
        let getMenuEnglishString = "/menu/english"
        return URL(string: serverAPI.appending(getMenuEnglishString))!
    }

    static func getCategoryURL() -> URL {
        let getCategoryString = "/user/categories"
        return URL(string: serverAPI.appending(getCategoryString))!
    }

    
    //Article
    static var getArticleLikeString = "/news/like/"
    static var getArticleUnLikeString = "/news/unlike/"
    static var getArticleSearchString = "/article/search/"
    static var getArticlePayString = server + "/taxapp/payments/authorize"

    static func getNewsURL() -> URL {
        let getNewsString = "/news"
        return URL(string: serverAPI.appending(getNewsString))!
    }
    
    
    //Message
    static func getMessageSentURL() -> URL {
        let getMessageSentString = "/message/sent"
        return URL(string: serverAPI.appending(getMessageSentString))!
    }
    
    static func getMessageInboxURL() -> URL {
        let getMessageInboxString = "/message/inbox"
        return URL(string: serverAPI.appending(getMessageInboxString))!
    }
    static func getMessageURL() -> URL {
        let getMessageString = "/message"
        return URL(string: serverAPI.appending(getMessageString))!
    }

    // English
    static var getArticlesEnglishString = serverAPI + "/english/section/"
    static var getArticleEnglishLikeString = serverAPI + "/english/like/"
     static var getArticleEnglishUnLikeString = serverAPI + "/english/unlike/"
    static var getArticleEnglishSearchString = serverAPI + "/english/search/"
    
  
}

