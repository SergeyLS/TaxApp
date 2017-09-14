//
//  SubMenuEnglish+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 9/14/17.
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

}
