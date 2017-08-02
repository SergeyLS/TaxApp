//
//  ListNewsViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/2/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import SideMenu

class ListNewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configSideMenu()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func configSideMenu()  {
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuWidth = view.layer.bounds.width * 0.8 //%
    }


}
