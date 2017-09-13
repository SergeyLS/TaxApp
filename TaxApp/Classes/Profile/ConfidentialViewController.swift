//
//  ConfidintialViewController.swift
//  TaxApp
//
//  Created by Sergey on 01.09.17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ConfidentialViewController: BaseImageViewController {
    //==================================================
    // MARK: - Properties
    //==================================================
    @IBOutlet weak var fonUI: UIImageView!
    @IBOutlet weak var confidentialTextView: UITextView!
    
    //==================================================
    // MARK: - LifeCicle
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        configTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = NSLocalizedString("Конфиденциальность", comment: "ConfidentialViewController - navigationItem.title")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        confidentialTextView.setContentOffset(CGPoint.zero, animated: false)
        confidentialTextView.layer.cornerRadius = 4;
    }
    
    //==================================================
    // MARK: - Configuration
    //==================================================
    func configTheme()  {
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.mainColor()
        fonUI.image = ThemeManager.shared.findImage(name: "confidentialFon", themeApp: ThemeManager.shared.currentTheme())
    }
}
