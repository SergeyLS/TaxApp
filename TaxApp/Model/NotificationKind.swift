//
//  NotificationKind.swift
//  Shopping List
//
//  Created by Sergey Leskov on 4/25/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation

enum NotificationKind: String {
    case none
    case inbox
    
    static func enumFromString(string: String) -> NotificationKind {
        switch string {
        case "inbox":
            return NotificationKind.inbox
         default:
            return NotificationKind.none
        }
    }

}
