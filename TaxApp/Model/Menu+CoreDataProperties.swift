//
//  Menu+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/19/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension Menu {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Menu> {
        return NSFetchRequest<Menu>(entityName: "Menu")
    }

    @NSManaged public var accessType: Int64
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var articlies: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for articlies
extension Menu {

    @objc(addArticliesObject:)
    @NSManaged public func addToArticlies(_ value: Article)

    @objc(removeArticliesObject:)
    @NSManaged public func removeFromArticlies(_ value: Article)

    @objc(addArticlies:)
    @NSManaged public func addToArticlies(_ values: NSSet)

    @objc(removeArticlies:)
    @NSManaged public func removeFromArticlies(_ values: NSSet)

}
