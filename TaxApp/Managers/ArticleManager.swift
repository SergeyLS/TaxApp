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
                completion(response.result.error?.localizedDescription)
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
                        
                        //dateUpdate
                        //                        if let tempDaties = tempElement["time"] as? [String: Any] {
                        //                            if let tempDate = tempDaties["updatedAtFormatted"] as? String {
                        //                                print(DateManager.datefromString(string: tempDate))
                        //                            }
                        //                        }
                        
                        
                        
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
    
    
    
    //getArticleFromAPI
    static func getArticleFromAPI(completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let req = request(ConfigAPI.getNewsURL(), method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error?.localizedDescription)
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
                        guard  let id = tempElement["id"] as? String
                            else {
                                print("Error: no id")
                                isErrors = true
                                continue
                        }
                        
                        //menu
                        guard  let menuId = tempElement["section_id"] as? Int
                            else {
                                print("Error: no menuId")
                                isErrors = true
                                continue
                        }
                        let menu = MenuManager.getMenuByID(id: menuId, context: moc)
                        if menu == nil {
                            print("Error: menu == nil")
                            isErrors = true
                            continue
                        }
                        
                        //dateUpdate
                        var dateUpdate = DateManager.dateNil
                        if let tempDaties = tempElement["time"] as? [String: Any] {
                            if let tempDate = tempDaties["updatedAtFormatted"] as? String {
                                dateUpdate = DateManager.datefromString(string: tempDate)
                            }
                        }
                        
                        //likes
                        let likes = tempElement["likes"] as? Int64 ?? 0
                        
                        
                        //go
                        if let article = getArticleByID(id: id )  {
                            //update
                            if dateUpdate > article.dateUpdate! {
                                article.update(article: article, menu: menu!, dictionary: tempElement as NSDictionary)
                            } else {
                                if article.likes != likes {
                                    article.likes = likes
                                }
                            }
                            
                        } else {
                            // New
                            if AppDataManager.shared.currentUser == nil {
                                continue
                            }
                            
                            guard let _ = Article(dictionary: tempElement as NSDictionary, menu: menu!, context: moc)   else {
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
    
    
    
    static func getImage(article: Article, completion: @escaping (_ image: UIImage) -> Void)  {
        
        let empfyPhoto = UIImage()
        
        if article.photo != nil {
            completion(article.photoImage!)
            return
        }
        
        guard let linkPhoto = article.linkPhoto else {
            completion(empfyPhoto)
            return
        }
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let req = request(linkPhoto, method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseData { response in
            if response.result.isFailure  {
                completion(empfyPhoto)
                return
            }
            
            let photoData = response.result.value
            //ImageManager.
            
            article.photo = photoData
            CoreDataManager.shared.saveContext()
            completion(article.photoImage!)
            return
        }
    } //func getImage
    
    
    
    //getArticleLike
    static func getArticleLike(article: Article, completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let articleIdString = article.id!
        let url = URL(string: ConfigAPI.serverAPI.appending(ConfigAPI.getArticleLikeString).appending(articleIdString))!
        
        let req = request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error?.localizedDescription)
                return
            }
            
            guard let array = response.result.value as? [String: Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            if let countLikes = (array["likes"] as? Int)  {
                
                article.isLike = true
                article.likes = Int64(countLikes)
                CoreDataManager.shared.saveContext()
                
                completion(nil)
                return
            }
            
            
            completion("Invalid func getArticleFromAPI")
            
        }
    }
    
    
    
    
    //getArticleFromAPI
    static func getArticleSearchFromAPI(search: String, completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let pathString = ConfigAPI.serverAPI.appending(ConfigAPI.getArticleSearchString).appending(search)
        
        //        let pathStringData = pathString.data(using: String.Encoding.nonLossyASCII)
        //        let utf8 = String(data: pathStringData!, encoding: String.Encoding.utf8)
        
        let utf8 = pathString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        let url = URL(string: utf8!)
        if url == nil  {
            completion("Error URL \(String(describing: utf8))")
            return
        }
        
        let req = request(url!, method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error?.localizedDescription)
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
                        
                        
                        guard  let menuId = tempElement["section_id"] as? Int
                            else {
                                print("Error: no menuId")
                                isErrors = true
                                continue
                        }
                        let menu = MenuManager.getMenuByID(id: menuId, context: moc)
                        if menu == nil {
                            print("Error: menu == nil")
                            isErrors = true
                            continue
                        }
                        
                        
                        
                        if let article = getArticleByID(id: id )  {
                            //update
                            article.forSearch = search
                        } else {
                            // New
                            if AppDataManager.shared.currentUser == nil {
                                continue
                            }
                            
                            guard let article = Article(dictionary: tempElement as NSDictionary, menu: menu!, context: moc)   else {
                                print("Error: Could not create a new Article from API.")
                                isErrors = true
                                continue
                            }
                            
                            article.forSearch = search
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
