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

class ArticleEnglishManager {
    
    //getArticleByID
    static func getArticleEnglishByID(id: String,
                               context: NSManagedObjectContext = CoreDataManager.shared.viewContext) -> ArticleEnglish? {
        
        if  id == "" { return nil }
        
        if AppDataManager.shared.currentUser == nil {
            return nil
        }
        
        let request = NSFetchRequest<ArticleEnglish>(entityName: ArticleEnglish.type)
        
        var arrayPredicate:[NSPredicate] = []
        arrayPredicate.append(NSPredicate(format: "user = %@", AppDataManager.shared.currentUser!))
        arrayPredicate.append(NSPredicate(format: "id = %@", id))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
        request.predicate = predicate
        
        let resultsArray = (try? context.fetch(request))
        
        return resultsArray?.first ?? nil
    }
    
    
    
    //getArticleFromAPI
    static func getArticleEnglishFromAPI(subMenuEnglish: SubMenuEnglish,
                                         completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer "+AppDataManager.shared.userToken,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let subMenuEnglishIdString = String(subMenuEnglish.id)
        let url = URL(string: ConfigAPI.getArticlesEnglishString.appending(subMenuEnglishIdString))!

        
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
                        guard  let id = tempElement["id"] as? String
                            else {
                                print("Error: no id")
                                isErrors = true
                                continue
                        }
                        
                        //likes
                        let likes = tempElement["likes"] as? Int64 ?? 0
                        
                        
                        //go
                        if let articleEnglish = getArticleEnglishByID(id: id, context:  moc)  {
                            articleEnglish.update(dictionary: tempElement as NSDictionary)
                            //update
                            if articleEnglish.likes != likes {
                                articleEnglish.likes = likes
                            }
                        
                        } else {
                            // New
                            if AppDataManager.shared.currentUser == nil {
                                continue
                            }
                            
                            guard let articleEnglish = ArticleEnglish(id: id, context: moc)   else {
                                print("Error: Could not create a new Article from API.")
                                isErrors = true
                                continue
                            }
                            articleEnglish.update(dictionary: tempElement as NSDictionary)
                            
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
    
    
    
    static func getImage(articleEnglish: ArticleEnglish, width: Int, height: Int, completion: @escaping (_ image: UIImage) -> Void)  {
        
        let empfyPhoto = UIImage()
        
        if articleEnglish.photo != nil {
            completion(articleEnglish.photoImage!)
            return
        }
        
        guard var linkPhoto = articleEnglish.linkPhoto else {
            completion(empfyPhoto)
            return
        }
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let indexChar = linkPhoto.findLastChar(charOfSerch: ".")
        if indexChar > 0 {
           let stringBefore = linkPhoto.substring(to: indexChar-1)
           let stringAfter = linkPhoto.substring(from: indexChar-1)
            
           linkPhoto = stringBefore + "_\(width)x\(height)" + stringAfter
        }
        
        

       let req = request(linkPhoto, method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseData { response in
            if response.result.isFailure  {
                completion(empfyPhoto)
                return
            }
            
            let photoData = response.result.value
            //ImageManager.
            
            articleEnglish.photo = photoData
            CoreDataManager.shared.saveContext()
            completion(articleEnglish.photoImage!)
            return
        }
    } //func getImage

    
    
    //getArticleLike
    static func getArticleEnglishLike(articleEnglish: ArticleEnglish, completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer "+AppDataManager.shared.userToken,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let articleIdString = articleEnglish.id!
        let url = URL(string: ConfigAPI.getArticleEnglishLikeString.appending(articleIdString))!
        
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
                
                articleEnglish.isLike = true
                articleEnglish.likes = Int64(countLikes)
                CoreDataManager.shared.saveContext()
                
                completion(nil)
                return
            }
            
            
            completion("Invalid func getArticleFromAPI")
            
        }
    }
    
    
    
    
    //getArticleFromAPI
    static func getArticleEnglishSearchFromAPI(search: String, completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer "+AppDataManager.shared.userToken,
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let pathString = ConfigAPI.getArticleEnglishSearchString.appending(search)
        
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
                        
                        
                        if let articleEnglish = getArticleEnglishByID(id: id, context: moc)  {
                            articleEnglish.update(dictionary: tempElement as NSDictionary)
                            articleEnglish.forSearch = search
                        } else {
                            // New
                            if AppDataManager.shared.currentUser == nil {
                                continue
                            }
                            
                            guard let articleEnglish = ArticleEnglish(id: id, context: moc)   else {
                                print("Error: Could not create a new Article from API.")
                                isErrors = true
                                continue
                            }
                            articleEnglish.update(dictionary: tempElement as NSDictionary)
                            
                            articleEnglish.forSearch = search
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
