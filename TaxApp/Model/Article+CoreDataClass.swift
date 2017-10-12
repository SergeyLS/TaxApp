//
//  Article+CoreDataClass.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Article: NSManagedObject {
    
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Article"
    
    
    var photoImage: UIImage? {
        if let tempPhoto = self.photo {
            return UIImage(data: tempPhoto)
        } else {
            return ImageManager.noImage
        }
    }
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    convenience init?(id: String, context: NSManagedObjectContext = CoreDataManager.shared.viewContext){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Article.type, in: context) else {
            fatalError("Could not initialize \(Article.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: context)
        
        self.id = id
     }
    
    
    func update(menu: Menu, dictionary: NSDictionary){
        
        var dateCreatedTemp = Date()
        var dateUpdateTemp = Date()
        if let tempDaties = dictionary["time"] as? [String: Any] {
            if let tempDate = tempDaties["createdAtFormatted"] as? String {
                dateCreatedTemp =  DateManager.datefromString(string: tempDate)
            }
            if let tempDate = tempDaties["updatedAtFormatted"] as? String {
                dateUpdateTemp =  DateManager.datefromString(string: tempDate)
            }
        }
        
        if let dateUpdateOld = dateUpdate {
            if dateUpdateTemp == dateUpdateOld {
                return
            }
        }
        dateCreated = dateCreatedTemp
        dateUpdate = dateUpdateTemp
        
        
        title = dictionary["title"] as? String ?? ""
        isCanOpen = dictionary["canOpen"] as? Bool ?? true
        link = dictionary["source_link"] as? String ?? ""
        shortDescr = dictionary["short_description"] as? String ?? ""
        linkPhoto = dictionary["imageLink"] as? String ?? ""
        linkText = dictionary["apiLink"] as? String ?? ""
        likes = dictionary["likes"] as? Int64 ?? 0
 
        let priceString = dictionary["price"] as? String ?? ""
        if let priceTemp = Double(priceString) {
            price = priceTemp
        }
        
        if let tempDaties = dictionary["time"] as? [String: Any] {
            if let tempDate = tempDaties["createdAtFormatted"] as? String {
                dateCreated =  DateManager.datefromString(string: tempDate)
            }
            if let tempDate = tempDaties["updatedAtFormatted"] as? String {
                dateUpdate =  DateManager.datefromString(string: tempDate)
            }
        }
        
        let context = managedObjectContext!
        self.menu = MenuManager.getMenuByID(id: Int(menu.id), context: context)
        self.user = UserManager.getUserByLogin(login: AppDataManager.shared.userLogin, context: context)
        
        print("add/update \(Article.type): " + title!)
    }
    
    
}
