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
            return UIImage(named: "noImage")
        }
    }
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    convenience init?(dictionary: NSDictionary, menu: Menu, context: NSManagedObjectContext = CoreDataManager.shared.viewContext){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Article.type, in: context) else {
            fatalError("Could not initialize \(Article.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: context)
        
        guard let tempCanOpen = dictionary["canOpen"] as? Bool,
            let tempTitle = dictionary["title"] as? String,
            let tempLink = dictionary["source_link"] as? String,
            let tempId = dictionary["id"] as? String,
            let tempDescr = dictionary["short_description"] as? String,
            let tempPhotoLink = dictionary["imageLink"] as? String,
            let tempLinkText = dictionary["apiLink"] as? String
            
            else {
                return nil
        }
        
        
        let priceString = dictionary["price"] as? String ?? ""
        
        if let priceTemp = Double(priceString) {
            price = priceTemp
        }
        
        likes = dictionary["likes"] as? Int64 ?? 0
        
        id = tempId
        title = tempTitle
        isCanOpen = tempCanOpen
        link = tempLink
        shortDescr = tempDescr
        linkPhoto = tempPhotoLink
        isLike = false
        linkText = tempLinkText
        
        if let tempDaties = dictionary["time"] as? [String: Any] {
            if let tempDate = tempDaties["createdAtFormatted"] as? String {
                dateCreated =  DateManager.datefromString(string: tempDate)
            }
            if let tempDate = tempDaties["updatedAtFormatted"] as? String {
                dateUpdate =  DateManager.datefromString(string: tempDate)
            }
        }
        
        dateCreated = dateCreated ?? Date()
        dateUpdate = dateUpdate ?? Date()
 
        self.menu = MenuManager.getMenuByID(id: Int(menu.id), context: context)
        self.user = UserManager.getUserByLogin(login: AppDataManager.shared.userLogin, context: context)
        
        print("add \(Article.type): " + title!)
    }
    
    
    func update(article: Article, menu: Menu, dictionary: NSDictionary, context: NSManagedObjectContext = CoreDataManager.shared.viewContext){
        
        title = dictionary["title"] as? String ?? ""
        isCanOpen = dictionary["canOpen"] as? Bool ?? true
        link = dictionary["source_link"] as? String ?? ""
        shortDescr = dictionary["short_description"] as? String ?? ""
        linkPhoto = dictionary["imageLink"] as? String ?? ""
        linkText = dictionary["apiLink"] as? String ?? ""
        price = dictionary["price"] as? Double ?? 0
        likes = dictionary["likes"] as? Int64 ?? 0
        
        if let tempDaties = dictionary["time"] as? [String: Any] {
            if let tempDate = tempDaties["createdAtFormatted"] as? String {
                dateCreated =  DateManager.datefromString(string: tempDate)
            }
            if let tempDate = tempDaties["updatedAtFormatted"] as? String {
                dateUpdate =  DateManager.datefromString(string: tempDate)
            }
        }
        
        dateCreated = dateCreated ?? Date()
        dateUpdate = dateUpdate ?? Date()
        
        self.menu = MenuManager.getMenuByID(id: Int(menu.id), context: context)
        self.user = UserManager.getUserByLogin(login: AppDataManager.shared.userLogin, context: context)
        
        print("update \(Article.type): " + title!)
    }


}
