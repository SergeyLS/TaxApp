//
//  SubMenuEnglish+CoreDataClass.swift
//  TaxApp
//
//  Created by Sergey Leskov on 9/14/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


public class SubMenuEnglish: NSManagedObject {

    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "SubMenuEnglish"
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    convenience init?(dictionary: NSDictionary,
                      menuEnglish: MenuEnglish){
        
        guard let context = menuEnglish.managedObjectContext else {
            return nil
        }
        
        guard let tempEntity = NSEntityDescription.entity(forEntityName: SubMenuEnglish.type, in: context) else {
            fatalError("Could not initialize \(SubMenuEnglish.type)")
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
        self.menuEnglish = menuEnglish
        
        print("add \(SubMenuEnglish.type): " + title!)
    }

}
