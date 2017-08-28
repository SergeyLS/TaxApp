//
//  Notification+CoreDataClass.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/28/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData

public class Notification: NSManagedObject {
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Notification"
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    convenience init?(notificationKind: NotificationKind,
                      context: NSManagedObjectContext = CoreDataManager.shared.viewContext) {
        
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Notification.type, in: context) else {
            fatalError("Could not initialize \(Notification.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: context)
        
        kind  = notificationKind.rawValue
        count = 0
        
        user = UserManager.getUserByLogin(login: AppDataManager.shared.userLogin, context: context)
        print("add \(Notification.type): " + kind!)
    }

}
