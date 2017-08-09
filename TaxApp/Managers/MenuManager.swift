//
//  MenuManager.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/5/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class MenuManager {
    
    //getMenuByID
    static func getMenuByID(id: Int,
                            context: NSManagedObjectContext = CoreDataManager.shared.viewContext) -> Menu? {
        
        if  id == 0 { return nil }
        
        if AppDataManager.shared.currentUser == nil {
            return nil
        }
        
        let request = NSFetchRequest<Menu>(entityName: Menu.type)

        var arrayPredicate:[NSPredicate] = []
        arrayPredicate.append(NSPredicate(format: "user = %@", AppDataManager.shared.currentUser!))
        arrayPredicate.append(NSPredicate(format: "id = %i", id))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
        request.predicate = predicate

        let resultsArray = (try? context.fetch(request))
        
        return resultsArray?.first ?? nil
    }
    
    
    //getMenuFromAPI
    static func getMenuFromAPI(completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let req = request(ConfigAPI.getMenuURL(), method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error! as? String)
                return
            }
            
            guard let menuJSON = response.result.value as? [Any] else {
                completion("Invalid tag information received from service")
                return
            }
            
            var isErrors = false
            
            let moc = CoreDataManager.shared.newBackgroundContext
            moc.performAndWait{
                for menu in menuJSON {
                    if let tempMenu = menu as? [String: Any] {
                        guard
                            let id = tempMenu["id"] as? Int
                            else {
                                print("error - no id")
                                isErrors = true
                                continue
                        }
                        

                        if let _ = getMenuByID(id: id )  {
                            //update
                            
                        } else {
                            // New
                            if AppDataManager.shared.currentUser == nil {
                                continue
                            }

                            guard let _ = Menu(dictionary: tempMenu as NSDictionary, context: moc)   else {
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
            
            completion("Invalid func getUserFromAPI")
            
        }
    }
    
    
    
    
}
