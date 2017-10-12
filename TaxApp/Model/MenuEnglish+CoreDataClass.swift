//
//  MenuEnglish+CoreDataClass.swift
//  TaxApp
//
//  Created by Sergey Leskov on 9/13/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public class MenuEnglish: NSManagedObject {

    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "MenuEnglish"
    
    
    var photoImage: UIImage? {
        if let tempPhoto = self.photo {
            return UIImage(data: tempPhoto)
        } else {
            return ImageManager.noImage
        }
    }

    //==================================================
    // MARK: - Initializers
    //==================================================
    convenience init?(dictionary: NSDictionary,
                      context: NSManagedObjectContext = CoreDataManager.shared.viewContext){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: MenuEnglish.type, in: context) else {
            fatalError("Could not initialize \(MenuEnglish.type)")
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
        
        if let icon = dictionary["icon"] as? String {
            switch icon {
            case "list-alt":
                photo = UIImagePNGRepresentation(UIImage(named: "englishResume")!)
            case "envelope":
                photo = UIImagePNGRepresentation(UIImage(named: "englishLetter")!)
            case "bullhorn":
                photo = UIImagePNGRepresentation(UIImage(named: "englishInterview")!)
            case "th-list":
                photo = UIImagePNGRepresentation(UIImage(named: "englishGlossary")!)
            case "user":
                photo = UIImagePNGRepresentation(UIImage(named: "englishDialogue")!)
            case "euro":
                photo = UIImagePNGRepresentation(UIImage(named: "englishTaxation")!)
 
            default:
                photo = nil
            }
        }
        
        self.user = UserManager.getUserByLogin(login: AppDataManager.shared.userLogin, context: context)
        
        print("add \(MenuEnglish.type): " + title!)
    }

}
