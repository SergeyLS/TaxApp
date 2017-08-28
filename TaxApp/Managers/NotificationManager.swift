//
//  NotificationManager.swift
//  Shopping List
//
//  Created by Sergey Leskov on 4/21/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


class NotificationManager {
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    //func getNotification
    static func getNotification(notificationKind: NotificationKind,
                                context: NSManagedObjectContext = CoreDataManager.shared.viewContext) -> Notification {
        let request = NSFetchRequest<Notification>(entityName: Notification.type)
       
        var arrayPredicate:[NSPredicate] = []
        arrayPredicate.append(NSPredicate(format: "user = %@", AppDataManager.shared.currentUser!))
        arrayPredicate.append(NSPredicate(format: "kind == %@", notificationKind.rawValue))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
        request.predicate = predicate
        
        request.fetchLimit = 1
        let resultsArray = try? context.fetch(request)
        
        if resultsArray?.count == 0 {
            let notification = Notification(notificationKind: notificationKind, context: context)
            return notification!
        } else {
            return resultsArray!.first!
        }
    }
    
    //func getNotificationCount
    static func getNotificationCount(notificationKind: NotificationKind) -> Int64 {
        return getNotification(notificationKind: notificationKind).count
    }
    
    
    //func allCount
    static func allCount() -> Int64 {
        let request = NSFetchRequest<Notification>(entityName: Notification.type)
        var arrayPredicate:[NSPredicate] = []
        arrayPredicate.append(NSPredicate(format: "user = %@", AppDataManager.shared.currentUser!))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
        request.predicate = predicate

        let resultsArray = try? CoreDataManager.shared.viewContext.fetch(request)
        
        if resultsArray?.count == 0 {
            return 0
        } else {
            var count: Int64 = 0
            for item in resultsArray! {
                count += item.count
            }
            return count
        }
    }
    
    //func clearNotification
    static func clearNotification(notificationKind: NotificationKind)  {
        let notification = getNotification(notificationKind: notificationKind)
        notification.count = 0
        CoreDataManager.shared.saveContext()
    }
    
    
}//END Of Class
