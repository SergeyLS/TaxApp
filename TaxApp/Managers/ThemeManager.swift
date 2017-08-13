//
//  ThemeManager.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/12/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import UIKit

enum ThemeApp: String {
    case morning = "Morning"
    case day = "Day"
    case night = "Night"
}

class ThemeManager{
    
    //==================================================
    // MARK: - Singleton
    //==================================================
    static let shared = ThemeManager()
    private init() {
    }

    
    private let theme1MinutesKey = "theme1Minutes";
    private let theme2MinutesKey = "theme2Minutes";
    private let theme3MinutesKey = "theme3Minutes";
 
    var theme1Minutes: Int {
        get {
            let result = (UserDefaults.standard.value(forKey: theme1MinutesKey) as? Int) ?? 360
            return result
        }
        set {
            UserDefaults.standard.set(newValue, forKey: theme1MinutesKey)
        }
    }
    
    var theme2Minutes: Int {
        get {
            let result = (UserDefaults.standard.value(forKey: theme2MinutesKey) as? Int) ?? 720
            return result
        }
        set {
            UserDefaults.standard.set(newValue, forKey: theme2MinutesKey)
        }
    }

    
    var theme3Minutes: Int {
        get {
            let result = (UserDefaults.standard.value(forKey: theme3MinutesKey) as? Int) ?? 1080
            return result
        }
        set {
            UserDefaults.standard.set(newValue, forKey: theme3MinutesKey)
        }
    }

    //currentTheme()
    func currentTheme() -> ThemeApp {
        
        let startDay = Calendar.current.startOfDay(for: Date())
        let minutes =  Calendar.current.dateComponents([.minute], from: startDay, to: Date()).minute
        
        if minutes! < theme1Minutes {
            return .night
        }
        if minutes! >= theme1Minutes &&  minutes! < theme2Minutes {
            return .morning
        }
        if minutes! >= theme2Minutes &&  minutes! < theme3Minutes {
            return .day
        }
        if minutes! >= theme3Minutes  {
            return .night
        }

        return .day //default
    }
    
    //mainColor()
    func mainColor() -> UIColor {
        switch currentTheme() {
        case .morning:
            return ColorManager.colorThemeMorning
        case .day:
            return ColorManager.colorThemeDay
        case .night:
            return ColorManager.colorThemeNight
        }
     }
    
    
    //findImage()
    func findImage(name: String, themeApp: ThemeApp) -> UIImage {
        var image = UIImage()
 
        if let tempImage = UIImage(named: name) {
            image = tempImage
        }
        
        let imageName = name + themeApp.rawValue
        if let tempImage = UIImage(named: imageName) {
            image = tempImage
        }
        
        return image
     }


}
