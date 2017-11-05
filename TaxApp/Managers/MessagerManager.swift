//
//  MessagersManager.swift
//  Shopping List
//
//  Created by Sergey Leskov on 4/19/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import SwiftMessages


class MessagerManager {
    
    static func showMessage(title: String, message: String, theme: Theme, layoutMessageView: MessageView.Layout = .messageView)  {
        let viewMessage: MessageView
        viewMessage = MessageView.viewFromNib(layout: layoutMessageView)
        viewMessage.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        let iconStyle: IconStyle = .subtle
        var config = SwiftMessages.defaultConfig
        
        //config.presentationStyle = .bottom
        
        switch theme {
        case .info:
            viewMessage.configureTheme(.info, iconStyle: iconStyle)
        case .success:
            viewMessage.configureTheme(.success, iconStyle: iconStyle)
        case .warning:
            viewMessage.configureTheme(.warning, iconStyle: iconStyle)
        case .error:
            viewMessage.configureTheme(.error, iconStyle: iconStyle)
        }
        
        viewMessage.configureDropShadow()
        viewMessage.button?.isHidden = true
        config.duration = .seconds(seconds: 1)
        config.interactiveHide = true
        
        SwiftMessages.show(config: config, view: viewMessage)
    }
}
