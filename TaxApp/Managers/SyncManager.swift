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
        print("[ProfileViewController] - requestData")
        
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
                
            }
            
            
        }
    }
    
}