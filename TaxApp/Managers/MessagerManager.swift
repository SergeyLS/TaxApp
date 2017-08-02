//
//  MessagersManager.swift
//  Shopping List
//
//  Created by Sergey Leskov on 4/19/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import SwiftMessages


class MessagerManager {
    
    static func showMessage(title: String, message: String, theme: Theme, view: UIView, layoutMessageView: MessageView.Layout = .MessageView)  {
        let view: MessageView
        view = MessageView.viewFromNib(layout: layoutMessageView)
        view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        let iconStyle: IconStyle = .subtle
        var config = SwiftMessages.defaultConfig
        
        //config.presentationStyle = .bottom
        
        switch theme {
        case .info:
            view.configureTheme(.info, iconStyle: iconStyle)
        case .success:
            view.configureTheme(.success, iconStyle: iconStyle)
        case .warning:
            view.configureTheme(.warning, iconStyle: iconStyle)
        case .error:
            view.configureTheme(.error, iconStyle: iconStyle)
        }
        
        view.configureDropShadow()
        view.button?.isHidden = true
        config.duration = .seconds(seconds: 1)
        config.interactiveHide = true
        
        SwiftMessages.show(config: config, view: view)
    }
}
