//
//  Menu+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/5/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension Menu {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Menu> {
        return NSFetchRequest<Menu>(entityName: "Menu")
    }

    @NSManaged public var id: Int
    @NSManaged public var accessType: Int
    @NSManaged public var title: String?
    @NSManaged public var user: User?

}
