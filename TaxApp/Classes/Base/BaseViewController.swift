//
//  BaseViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/1/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


//==================================================
// MARK: - UITextFieldDelegate
//==================================================
extension BaseViewController: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ nameField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
}