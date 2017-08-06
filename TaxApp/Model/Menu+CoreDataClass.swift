//
//  Menu+CoreDataClass.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/5/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


public class Menu: NSManagedObject {

    
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Menu"
    
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    convenience init?(dictionary: NSDictionary, context: NSManagedObjectContext = CoreDataManager.shared.viewContext){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Menu.type, in: context) else {
            fatalError("Could not initialize \(Menu.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: context)
        
        guard let tempId = dictionary["id"] as? Int,
            let tempTitle = dictionary["title"] as? String,
            let TempAccessType = dictionary["access_type"] as? Int
            else {
                 return nil
        }
        
        
        id = tempId
        accessType = TempAccessType
        title = tempTitle
        
        self.user = UserManager.getUserByLogin(login: AppDataManager.shared.userLogin, context: context)
        
        print("add \(Menu.type): " + title!)
    }

}
