//
//  User+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/1/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userName: String?
    @NSManaged public var eMail: String?
    @NSManaged public var firstName: String?
    @NSManaged public var middleName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var categoryID: String?
    @NSManaged public var authID: String?

}
