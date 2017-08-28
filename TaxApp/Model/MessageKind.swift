//
//  MessageKind.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/28/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation

enum MessageKind: String {
    case inbox
    case sent
    case delete
    
    static func enumFromString(string: String) -> MessageKind {
        switch string {
        case "inbox":
            return MessageKind.inbox
        case "sent":
            return MessageKind.sent
        case "delete":
            return MessageKind.delete
        default:
            return MessageKind.inbox
        }
    }
    
    func localized() -> String {
        switch self {
        case .inbox:
            return NSLocalizedString("Входящие",        comment: "enum MessageKind - inbox")
        case .sent:
            return NSLocalizedString("Отправленные",    comment: "enum MessageKind - sent")
        case .delete:
            return NSLocalizedString("Удаленные",       comment: "enum MessageKind - delete")
        }
    }

    
}
