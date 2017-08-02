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
    
    private let userNameKey = "userName";
    private let userTokenKey = "userToken";
    
    //var userName
    public var userName: String? {
        get {
            let result = UserDefaults.standard.value(forKey: userNameKey) as? String
            return result
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userNameKey)
        }
    }
    
    //var userToken
    public var userToken: String? {
        get {
            let result = UserDefaults.standard.value(forKey: userTokenKey) as? String
            return result
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userTokenKey)
        }
    }


}
