//
//  MenuEnglish+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 9/15/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension MenuEnglish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuEnglish> {
        return NSFetchRequest<MenuEnglish>(entityName: "MenuEnglish")
    }

    @NSManaged public var id: Int64
    @NSManaged public var photo: Data?
    @NSManaged public var title: String?
    @NSManaged public var subMenuMany: NSSet?
    @NSManaged public var user: User?
    @NSManaged public var articleEnglishMany: NSSet?

}

// MARK: Generated accessors for subMenuMany
extension MenuEnglish {

    @objc(addSubMenuManyObject:)
    @NSManaged public func addToSubMenuMany(_ value: SubMenuEnglish)

    @objc(removeSubMenuManyObject:)
    @NSManaged public func removeFromSubMenuMany(_ value: SubMenuEnglish)

    @objc(addSubMenuMany:)
    @NSManaged public func addToSubMenuMany(_ values: NSSet)

    @objc(removeSubMenuMany:)
    @NSManaged public func removeFromSubMenuMany(_ values: NSSet)

}

// MARK: Generated accessors for articleEnglishMany
extension MenuEnglish {

    @objc(addArticleEnglishManyObject:)
    @NSManaged public func addToArticleEnglishMany(_ value: ArticleEnglish)

    @objc(removeArticleEnglishManyObject:)
    @NSManaged public func removeFromArticleEnglishMany(_ value: ArticleEnglish)

    @objc(addArticleEnglishMany:)
    @NSManaged public func addToArticleEnglishMany(_ values: NSSet)

    @objc(removeArticleEnglishMany:)
    @NSManaged public func removeFromArticleEnglishMany(_ values: NSSet)

}
