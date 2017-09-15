//
//  SubMenuEnglish+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 9/15/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension SubMenuEnglish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubMenuEnglish> {
        return NSFetchRequest<SubMenuEnglish>(entityName: "SubMenuEnglish")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var menuEnglish: MenuEnglish?
    @NSManaged public var articleEnglishMany: NSSet?

}

// MARK: Generated accessors for articleEnglishMany
extension SubMenuEnglish {

    @objc(addArticleEnglishManyObject:)
    @NSManaged public func addToArticleEnglishMany(_ value: ArticleEnglish)

    @objc(removeArticleEnglishManyObject:)
    @NSManaged public func removeFromArticleEnglishMany(_ value: ArticleEnglish)

    @objc(addArticleEnglishMany:)
    @NSManaged public func addToArticleEnglishMany(_ values: NSSet)

    @objc(removeArticleEnglishMany:)
    @NSManaged public func removeFromArticleEnglishMany(_ values: NSSet)

}
