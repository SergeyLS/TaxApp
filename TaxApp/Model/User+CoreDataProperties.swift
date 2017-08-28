//
//  User+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/28/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var eMail: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastLogin: Date?
    @NSManaged public var lastName: String?
    @NSManaged public var middleName: String?
    @NSManaged public var photo: Data?
    @NSManaged public var userName: String?
    @NSManaged public var articlies: NSSet?
    @NSManaged public var category: Category?
    @NSManaged public var menuMany: NSSet?
    @NSManaged public var notifications: NSSet?
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for articlies
extension User {

    @objc(addArticliesObject:)
    @NSManaged public func addToArticlies(_ value: Article)

    @objc(removeArticliesObject:)
    @NSManaged public func removeFromArticlies(_ value: Article)

    @objc(addArticlies:)
    @NSManaged public func addToArticlies(_ values: NSSet)

    @objc(removeArticlies:)
    @NSManaged public func removeFromArticlies(_ values: NSSet)

}

// MARK: Generated accessors for menuMany
extension User {

    @objc(addMenuManyObject:)
    @NSManaged public func addToMenuMany(_ value: Menu)

    @objc(removeMenuManyObject:)
    @NSManaged public func removeFromMenuMany(_ value: Menu)

    @objc(addMenuMany:)
    @NSManaged public func addToMenuMany(_ values: NSSet)

    @objc(removeMenuMany:)
    @NSManaged public func removeFromMenuMany(_ values: NSSet)

}

// MARK: Generated accessors for notifications
extension User {

    @objc(addNotificationsObject:)
    @NSManaged public func addToNotifications(_ value: Notification)

    @objc(removeNotificationsObject:)
    @NSManaged public func removeFromNotifications(_ value: Notification)

    @objc(addNotifications:)
    @NSManaged public func addToNotifications(_ values: NSSet)

    @objc(removeNotifications:)
    @NSManaged public func removeFromNotifications(_ values: NSSet)

}

// MARK: Generated accessors for messages
extension User {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
