//
//  AboutApp.swift
//  TaxApp
//
//  Created by Sergey on 01.09.17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class AboutApp: BaseImageViewController {
    //==================================================
    // MARK: - Properties
    //==================================================
    @IBOutlet weak var fonUI: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    //==================================================
    // MARK: - LifeCicle
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        configTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = NSLocalizedString("О приложении", comment: "AboutAppViewController - navigationItem.title")
        bottomView.layer.cornerRadius = 4;
    }
    
    //==================================================
    // MARK: - Configuration
    //==================================================
    func configTheme()  {
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.mainColor()
        fonUI.image = ThemeManager.shared.findImage(name: "aboutFon", themeApp: ThemeManager.shared.currentTheme())
    }
}
