//
//  CategoryManager.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/17/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class CategoryManager {
    
    //getCategoryByID
    static func getCategoryByID(id: Int,
                                context: NSManagedObjectContext = CoreDataManager.shared.viewContext) -> Category? {
        
        if  id == 0 { return nil }
        
        let request = NSFetchRequest<Category>(entityName: Category.type)
        
        var arrayPredicate:[NSPredicate] = []
        arrayPredicate.append(NSPredicate(format: "id = %i", id))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
        request.predicate = predicate
        
        let resultsArray = (try? context.fetch(request))
        
        return resultsArray?.first ?? nil
    }
    
    
    //getCategoryFromAPI
    static func getCategoryFromAPI(completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let req = request(ConfigAPI.getCategoryURL(), method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error?.localizedDescription)
                return
            }
            
            guard let categoryJSON = response.result.value as? [Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            var isErrors = false
            
            let moc = CoreDataManager.shared.newBackgroundContext
            moc.performAndWait{
                for category in categoryJSON {
                    if let tempCatgory = category as? [String: Any] {
                        guard
                            let id = tempCatgory["id"] as? Int
                            else {
                                print("error - no id")
                                isErrors = true
                                continue
                        }
                        
                        
                        if let _ = getCategoryByID(id: id )  {
                            //update
                            
                        } else {
                            // New
                            guard let _ = Category(dictionary: tempCatgory as NSDictionary, context: moc)   else {
                                print("Error: Could not create a new Menu from API.")
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
            
            completion("Invalid func getCategoryFromAPI")
            
        }
    }
    
    
    
    
}
