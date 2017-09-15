//
//  MenuEnglishManager.swift
//  TaxApp
//
//  Created by Sergey Leskov on 9/14/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class MenuManagerEnglish {
    
    //getMenuByID
    static func getMenuEnglishByID(id: Int64,
                            context: NSManagedObjectContext = CoreDataManager.shared.viewContext) -> MenuEnglish? {
        
        if  id == 0 { return nil }
        
        if AppDataManager.shared.currentUser == nil {
            return nil
        }
        
        let request = NSFetchRequest<MenuEnglish>(entityName: MenuEnglish.type)
        
        var arrayPredicate:[NSPredicate] = []
        arrayPredicate.append(NSPredicate(format: "user = %@", AppDataManager.shared.currentUser!))
        arrayPredicate.append(NSPredicate(format: "id = %i", id))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
        request.predicate = predicate
        
        let resultsArray = (try? context.fetch(request))
        
        return resultsArray?.first ?? nil
    }
    
    
    //getSubMenuEnglishByID
    static func getSubMenuEnglishByID(id: Int64,
                                      menuEnglish: MenuEnglish?) -> SubMenuEnglish? {
        
        if  id == 0 { return nil }
        
        if menuEnglish == nil {
            return nil
        }
        
        let request = NSFetchRequest<SubMenuEnglish>(entityName: SubMenuEnglish.type)
        
        var arrayPredicate:[NSPredicate] = []
        arrayPredicate.append(NSPredicate(format: "menuEnglish = %@", menuEnglish!))
        arrayPredicate.append(NSPredicate(format: "id = %i", id))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
        request.predicate = predicate
        
        let resultsArray = (try? menuEnglish!.managedObjectContext!.fetch(request))
        
        return resultsArray?.first ?? nil
    }

    
    //loadSections
    static func loadSections(sections: [Any], menuEnglish: MenuEnglish, context: NSManagedObjectContext)  {
        for section in sections {
            if let tempSection = section as? [String: Any] {
                
                guard
                    let id = tempSection["id"] as? Int64
                    else {
                        print("error - no section id")
                        continue
                }
                
                if let _ = getSubMenuEnglishByID(id: Int64(id), menuEnglish: menuEnglish)  {
                    //update
                } else {
                    // New
                    guard let _ = SubMenuEnglish(dictionary: tempSection as NSDictionary, menuEnglish: menuEnglish)   else {
                        print("Error: Could not create a new Menu from API.")
                        continue
                    }
                } //else
                
            }
        }
        
    }
    
    //getMenuFromAPI
    static func getMenuEnglishFromAPI(completion: @escaping (_ error: String?) -> Void)  {
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let req = request(ConfigAPI.getMenuEnglishURL(), method: .get, encoding: JSONEncoding.default, headers: headers)
        
        req.responseJSON { response in
            if response.result.isFailure  {
                //print(response.result.error!)
                completion(response.result.error?.localizedDescription)
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
                            let id = tempMenu["id"] as? Int64
                            else {
                                print("error - no id")
                                isErrors = true
                                continue
                        }
                        
                        var menuEnglish: MenuEnglish?
                        
                        if let oldMenu = getMenuEnglishByID(id: id )  {
                            //update
                            menuEnglish = oldMenu
                        } else {
                            // New
                            if AppDataManager.shared.currentUser == nil {
                                continue
                            }
                            
                            guard let newMenu = MenuEnglish(dictionary: tempMenu as NSDictionary, context: moc)   else {
                                print("Error: Could not create a new Menu from API.")
                                isErrors = true
                                continue
                            }
                            menuEnglish = newMenu
                        } //else
                        
                        //subMenu
                        if menuEnglish == nil {
                            continue
                        }
                        
                        
                        if let sections = tempMenu["sections"] as? [Any] {
                            loadSections(sections: sections, menuEnglish: menuEnglish!, context: moc)
                         }
                        
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

