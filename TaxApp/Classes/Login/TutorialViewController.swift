//
//  TutorialViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 9/21/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

     @IBOutlet weak var fonUI: UIImageView!
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()

        configTheme()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(callback), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        fonUI.image = ThemeManager.shared.findImage(name: "startLogo", themeApp: ThemeManager.shared.currentTheme())
    }

    @objc func callback() {
        //reloadData(animated: false)
        if let _ = AppDataManager.shared.currentUser {
            performSegue(withIdentifier: "openNews", sender: nil)
        } else {
            performSegue(withIdentifier: "login", sender: nil)
        }
        
    }

}
