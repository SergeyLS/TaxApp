//
//  Article+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var id: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var shortDescr: String?
    @NSManaged public var link: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var isCanOpen: Bool
    @NSManaged public var photo: Data?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateUpdate: Date?
    @NSManaged public var linkPhoto: String?
    @NSManaged public var isLike: Bool
    @NSManaged public var forSearch: String
    @NSManaged public var linkText: String?
    @NSManaged public var likes: Int64
    
    @NSManaged public var user: User?
    @NSManaged public var menu: Menu?

}
