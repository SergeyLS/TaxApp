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
    static func getNotification(notificationKind: NotificationKind) -> Notification {
        let request = NSFetchRequest<Notification>(entityName: Notification.type)
        let predicate = NSPredicate(format: "kind == %@", String(describing: notificationKind))
        request.predicate = predicate
        request.fetchLimit = 1
        let resultsArray = try? CoreDataManager.shared.viewContext.fetch(request)
        
        if resultsArray?.count == 0 {
            let notification = Notification(notificationKind: notificationKind)
//            CoreDataManager.shared.save()
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
    
    // func updateNotification
    static func updateNotification()  {
        CoreDataManager.shared.saveContext()
    }
    
    
    //func clearNotification
    static func clearNotification(notificationKind: NotificationKind)  {
        let notification = getNotification(notificationKind: notificationKind)
        notification.count = 0
        updateNotification()
    }
    
    
}//END Of Class
