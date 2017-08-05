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
        
        self.navigationController?.navigationBar.topItem?.title = ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //==================================================
    // MARK: - config
    //==================================================
    func configButton(button: UIButton)  {
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        button.layer.cornerRadius = 5
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
