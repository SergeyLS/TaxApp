//
//  String+Extensions.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/18/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation


extension String {
    func toDouble() -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //formatter.locale = locale
        formatter.usesGroupingSeparator = true
        if let result = formatter.number(from: self)?.doubleValue {
            return result
        } else {
            return 0
        }
    }
}
