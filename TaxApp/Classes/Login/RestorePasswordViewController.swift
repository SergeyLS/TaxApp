//
//  RestorePasswordViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/5/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class RestorePasswordViewController: BaseViewController {

    @IBOutlet weak var eMailFieldUI: UITextField!
    @IBOutlet weak var restoreButtonUI: UIButton!
    

    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()

        eMailFieldUI.delegate = self
        
        configButton(button: restoreButtonUI)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = NSLocalizedString("Восстановление", comment: "RestorePasswordViewController - navigationItem.title")
    }

    //==================================================
    // MARK: - action
    //==================================================
    @IBAction func restoreAction(_ sender: UIButton) {
    }


}
