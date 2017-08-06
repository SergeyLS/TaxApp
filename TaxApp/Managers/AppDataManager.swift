//
//  AppDataManager.swift
//  SwotseAPI
//
//  Created by Sergey Leskov on 6/1/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData

class AppDataManager {
    
    //==================================================
    // MARK: - Singleton
    //==================================================
    public static let shared = AppDataManager()
    private init() {
    }
    
    
    //==================================================
    // MARK: - Application Settings
    //==================================================
    
    private let userTokenKey = "userToken";
    private let userLoginKey = "userLogin";
    
    public var userToken: String {
        get {
            let result = (UserDefaults.standard.value(forKey: userTokenKey) as? String) ?? ""
            return result
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userTokenKey)
        }
    }
    
    public var userLogin: String {
        get {
            let result = (UserDefaults.standard.value(forKey: userLoginKey) as? String) ?? ""
            return result
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userLoginKey)
        }
    }


    
    public var currentUser: User? {
        
        if AppDataManager.shared.userLogin == "" {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastLogin", ascending: true)]
        let predicate = NSPredicate(format: "userName == %@", AppDataManager.shared.userLogin)
        fetchRequest.predicate = predicate
        let results = (try? CoreDataManager.shared.viewContext.fetch(fetchRequest)) as? [User] ?? []
        return results.first ?? nil
    }


}
