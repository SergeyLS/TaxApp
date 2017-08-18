//
//  Category+CoreDataClass.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/17/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData

public class Category: NSManagedObject {
    
    static let type = "Category"
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    convenience init?(dictionary: NSDictionary,
                      context: NSManagedObjectContext = CoreDataManager.shared.viewContext){
        
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Category.type, in: context) else {
            fatalError("Could not initialize \(Category.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: context)
        
        guard let tempId = dictionary["id"] as? Int,
            let tempTitle = dictionary["title"] as? String
            else {
                return nil
        }
        
        
        id = Int64(tempId)
        title = tempTitle
        
        print("add \(Category.type): " + title!)
    }
    
}
