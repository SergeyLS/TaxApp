//
//  SyncManager.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/28/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import UIKit

class SyncManager{
    
    static func syncMenu(view: UIView)  {
        print("[SyncManager] - syncMenu")
        
        MenuManager.getMenuFromAPI() { (error) in
            if let error = error  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: view)
                return
            }
        }
    }
    
    
    static func syncEnglishMenu(view: UIView)  {
        print("[SyncManager] - syncEnglishMenu")
        
        MenuManagerEnglish.getMenuEnglishFromAPI() { (error) in
            if let error = error  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: view)
                return
            }
        }
    }

    
    static func syncArticles(view: UIView)  {
        print("[SyncManager] - syncArticles")
        
        MenuManager.getMenuFromAPI() { (errorMenu) in
            if let error = errorMenu  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: view)
                return
            }
            
            ArticleManager.getArticleFromAPI() { (errorArticle) in
                if let error = errorArticle  {
                    MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: view)
                    return
                }
                
            }
        }
    }
    
    
    static func syncMessages(view: UIView)  {
        
        if AppDataManager.shared.userLogin == User.noLoginUserKey {
            return
        }

        print("[SyncManager] - syncMessages")
        MessageManager.getMessageFromAPI(messageKind: MessageKind.inbox) { (error) in
            if let error = error  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: view)
                return
            }
            
            MessageManager.getMessageFromAPI(messageKind: MessageKind.sent) { (error) in
                if let error = error  {
                    MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: view)
                    return
                }
                
                MessageManager.setMainID() 
                
            }
            
            
        }
    }
    
}
