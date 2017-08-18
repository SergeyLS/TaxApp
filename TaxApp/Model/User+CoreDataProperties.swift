//
//  User+CoreDataProperties.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/5/17.
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
    @NSManaged public var lastName: String?
    @NSManaged public var middleName: String?
    @NSManaged public var userName: String?
    @NSManaged public var lastLogin: Date?
    @NSManaged public var photo: Data?
    
    @NSManaged public var category: Category?
    
    @NSManaged public var menuMany: NSSet?
    @NSManaged public var articlies: NSSet?

}

