//
//  DateManager.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/9/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation

class DateManager {
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    static let dateNil = Date(timeIntervalSince1970: 0)
    
    
    static func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        return formatter.string(from: date)
    }
    
    
    static func dateAndTimeToString(date: Date) -> String {
        
        return DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
    }
    
    
    //datefromString
    static func datefromString(string: String) -> Date {
        var date = Date()
        
        let dateFormatter = DateFormatter()
   
        //http://userguide.icu-project.org/formatparse/datetime
        //https://docs.python.org/3/library/datetime.html#strftime-strptime-behavior

        //Tue, 11 Apr 2017 13:40:00 PDT
        //dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        
        //"%Y-%m-%dT%H:%M:%S.%fZ"
        //2017-06-01T17:05:12.077245Z
        
        //2017-07-15 11:04:11 UTC
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        
        if let tempDate = dateFormatter.date(from: string) {
            date = tempDate
        }
        return date
    }

    
}
