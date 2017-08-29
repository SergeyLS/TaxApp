//
//  Message+CoreDataClass.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/28/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


public class Message: NSManagedObject {
    
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Message"
    
    
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    convenience init?(dictionary: NSDictionary,
                      messageKind: MessageKind,
                      context: NSManagedObjectContext = CoreDataManager.shared.viewContext){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Message.type, in: context) else {
            fatalError("Could not initialize \(Message.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: context)
        
        guard
            let tempText = dictionary["body"] as? String,
            let tempId = dictionary["id"] as? Int64
            else {
                return nil
        }
        
        id = tempId
        text = tempText
        
        if messageKind == .inbox {
            isNew = true
            let notification = NotificationManager.getNotification(notificationKind: .inbox, context: context)
            notification.count = notification.count + 1
        }
    }
    
    
    func update(dictionary: NSDictionary,
                messageKind: MessageKind)  {
        
        var dateCreatedTemp = Date()
        var dateUpdateTemp = Date()
        if let tempDaties = dictionary["time"] as? [String: Any] {
            if let tempDate = tempDaties["createdAtFormatted"] as? String {
                dateCreatedTemp =  DateManager.datefromString(string: tempDate)
            }
            if let tempDate = tempDaties["updatedAtFormatted"] as? String {
                dateUpdateTemp =  DateManager.datefromString(string: tempDate)
            }
        }
        
        if let dateUpdateOld = dateUpdate {
            if dateUpdateTemp == dateUpdateOld {
                return
            }
        }
        dateCreated = dateCreatedTemp
        dateUpdate = dateUpdateTemp
        
        replyID = dictionary["reply_id"] as? Int64 ?? 0
        
        text = dictionary["body"] as? String ?? ""
        
        let isDelete = dictionary["deleted"] as? Bool ?? false
        if isDelete {
            kind = MessageKind.delete.rawValue
        } else {
            kind = messageKind.rawValue
        }
        
        
        let context = managedObjectContext
        self.user = UserManager.getUserByLogin(login: AppDataManager.shared.userLogin, context: context!)
        
        print("add/change \(Message.type): " + text!)
        
    }
}
