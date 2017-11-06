//
//  ArticleEnglish+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 11/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//
//

import Foundation
import CoreData


extension ArticleEnglish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEnglish> {
        return NSFetchRequest<ArticleEnglish>(entityName: "ArticleEnglish")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateUpdate: Date?
    @NSManaged public var forSearch: String?
    @NSManaged public var id: String?
    @NSManaged public var isCanOpen: Bool
    @NSManaged public var isLike: Bool
    @NSManaged public var likes: Int64
    @NSManaged public var link: String?
    @NSManaged public var linkPhoto: String?
    @NSManaged public var linkText: String?
    @NSManaged public var photo: Data?
    @NSManaged public var price: Double
    @NSManaged public var shortDescr: String?
    @NSManaged public var title: String?
    @NSManaged public var menuEnglish: MenuEnglish?
    @NSManaged public var subMenuEnglish: SubMenuEnglish?
    @NSManaged public var user: User?

}
