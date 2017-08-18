//
//  User+CoreDataClass.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/1/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class User: NSManagedObject {
 
    static let type = "User"
    static let noLoginUserKey = "noLoginUser"
    
    var photoImage: UIImage? {
        if let tempPhoto = self.photo {
            return UIImage(data: tempPhoto)
        } else {
            return UIImage(named: "noImage")
        }
        
    }
    
    var fullName: String {
        return "\(self.firstName == nil ? "" : self.firstName!) \(self.lastName == nil ? "" : self.lastName!)"
    }
    

    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    convenience init?(userName: String){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: User.type, in: CoreDataManager.shared.viewContext) else {
            fatalError("Could not initialize \(User.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: CoreDataManager.shared.viewContext)
        self.userName = userName
        
        print("add new \(User.type): \(userName)")
    }

}
