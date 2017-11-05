//
//  UsefulFunctions.swift
//  TaxApp
//
//  Created by Sergey Leskov on 11/5/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation


class UsefulFunctions {
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    
    //==================================================
    // MARK: - func
    //==================================================
    static func version(isShowBuild: Bool = false) -> String {
        var rez = ""
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        
        rez += "\(version)"
        if isShowBuild {
            rez += ".\(build)"
        }
        
        return rez
    }
    
    
    
}
