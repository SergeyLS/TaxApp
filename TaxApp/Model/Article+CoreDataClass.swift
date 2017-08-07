//
//  Article+CoreDataClass.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


public class Article: NSManagedObject {

    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Article"
    
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    convenience init?(dictionary: NSDictionary, menu: Menu, context: NSManagedObjectContext = CoreDataManager.shared.viewContext){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Article.type, in: context) else {
            fatalError("Could not initialize \(Article.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: context)
        
        guard let tempCanOpen = dictionary["canOpen"] as? Bool,
            let tempTitle = dictionary["title"] as? String,
            let tempLink = dictionary["source_link"] as? String,
            let tempId = dictionary["id"] as? String,
            let tempDescr = dictionary["short_description"] as? String
            else {
                return nil
        }
        
        
        id = tempId
        title = tempTitle
        isCanOpen = tempCanOpen
        link = tempLink
        shortDescr = tempDescr
 
        self.menu = MenuManager.getMenuByID(id: Int(menu.id), context: context)
        self.user = UserManager.getUserByLogin(login: AppDataManager.shared.userLogin, context: context)
        
        print("add \(Article.type): " + title!)
    }

}
