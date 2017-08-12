//
//  BaseNavigationViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/12/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    
    @IBOutlet weak var navBarUI: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBarUI.barTintColor = ThemeManager.shared.mainColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
