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
    
    //==================================================
    // MARK: - action
    //==================================================
    @IBAction func ratingButton(_ sender: UIButton) {
        if let url = URL(string: "https://itunes.apple.com/us/app/tax-app/id1268527832?l=ru&ls=1&mt=8") {
            UIApplication.shared.open(url)
        }
    }
    
    
    @IBAction func recommendButton(_ sender: UIButton) {
        let defaultText = "Рекомендую!"
        
        var activityItems = [Any]()
        activityItems.append(defaultText)
        if let image = UIImage(named: "logo") {
            activityItems.append(image)
        }
//        if let url = URL(string: article.linkText!) {
//            activityItems.append(url)
//        }
        
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)

    }
    
    
}
