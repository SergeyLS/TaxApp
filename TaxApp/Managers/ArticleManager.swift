//
//  ArticleManager.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class ArticleManager {
    
    //getArticleByID
    static func getArticleByID(id: String) -> Article? {
        
        if  id == "" { return nil }
        
        if AppDataManager.shared.currentUser == nil {
            return nil
        }
        
        let request = NSFetchRequest<Article>(entityName: Article.type)
        
        var arrayPredicate:[NSPredicate] = []
        arrayPredicate.append(NSPredicate(format: "user = %@", AppDataManager.shared.currentUser!))
        arrayPredicate.append(NSPredicate(format: "id = %@", id))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
        request.predicate = predicate
        
        let resultsArray = (try? CoreDataManager.shared.viewContext.fetch(request))
        
        return resultsArray?.first ?? nil
    }
    
    
    //getArticleFromAPI
    static func getArticleFromAPI(menu: Menu, completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let menuIdString = String(describing: menu.id)
        let url = URL(string: ConfigAPI.serverAPI.appending(ConfigAPI.getArticleString).appending(menuIdString))!
        
        let req = request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error! as? String)
                return
            }
            
            guard let array = response.result.value as? [Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            var isErrors = false
            
            let moc = CoreDataManager.shared.newBackgroundContext
            moc.performAndWait{
                for element in array {
                    if let tempElement = element as? [String: Any] {
                        guard
                            let id = tempElement["id"] as? String
                            else {
                                print("error - no id")
                                isErrors = true
                                continue
                        }
                        
                        
                        if let _ = getArticleByID(id: id )  {
                            //update
                            
                        } else {
                            // New
                            if AppDataManager.shared.currentUser == nil {
                                continue
                            }
                            
                            
                            guard let _ = Article(dictionary: tempElement as NSDictionary, menu: menu, context: moc)   else {
                                print("Error: Could not create a new Article from API.")
                                isErrors = true
                                continue
                            }
                            
                        } //else
                    }
                }
                CoreDataManager.shared.save(context: moc)
            }
            
            
            if isErrors == false {
                completion(nil)
                return
            }
            
            completion("Invalid func getArticleFromAPI")
            
        }
    }
    
    
    
    
}
