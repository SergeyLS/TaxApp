//
//  Notification+CoreDataClass.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/28/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData

@objc(Notification)
public class Notification: NSManagedObject {
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Notification"
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    convenience init?(notificationKind: NotificationKind) {
        
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Notification.type, in: CoreDataManager.shared.viewContext) else {
            fatalError("Could not initialize \(Notification.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: CoreDataManager.shared.viewContext)
        
        kind  = String(describing: notificationKind)
        count = 0
        
        user = AppDataManager.shared.currentUser
    }

}
