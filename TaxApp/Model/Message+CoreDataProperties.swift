//
//  Message+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/28/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var kind: String?
    @NSManaged public var id: Int64
    @NSManaged public var text: String?
    @NSManaged public var replyID: Int64
    @NSManaged public var isReadUser: Bool
    @NSManaged public var isReadAdmin: Bool
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateUpdate: Date?
    @NSManaged public var isDelete: Bool
    @NSManaged public var user: User?
    @NSManaged public var isNew: Bool

}
