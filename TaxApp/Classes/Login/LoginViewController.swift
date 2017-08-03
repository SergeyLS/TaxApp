//
//  LoginViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/1/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    
    @IBOutlet weak var facebookButtonUI: UIButton!
    @IBOutlet weak var twitterButtonUI: UIButton!
    @IBOutlet weak var googleButtonUI: UIButton!
    @IBOutlet weak var enterButtonUI: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var signUpButtonUI: UIButton!
    
    @IBOutlet weak var eMailFieldUI: UITextField!
    @IBOutlet weak var passwordFieldUI: UITextField!
 
    
    var activeTextField: UITextField?
    var contentInsets: UIEdgeInsets?

    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        eMailFieldUI.delegate = self
        passwordFieldUI.delegate = self
        
        congigButton(button: facebookButtonUI)
        congigButton(button: twitterButtonUI)
        congigButton(button: googleButtonUI)
        congigButton(button: enterButtonUI)
        congigButton(button: nextButton)
        congigButton(button: signUpButtonUI)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     }

    //==================================================
    // MARK: - config
    //==================================================
    func congigButton(button: UIButton)  {
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        button.layer.cornerRadius = 5
    }

    //==================================================
    // MARK: - action
    //==================================================
    @IBAction func signInAction(_ sender: UIButton) {
       
        let password = passwordFieldUI.text!
        let eMail = eMailFieldUI.text!
        let name = eMail
        
        if name == "" || password == "" || eMail == "" {
            let title = NSLocalizedString("Oops!", comment: "Oops")
            let message = NSLocalizedString("Not filled in all required fields!", comment: "Not filled in all required fields")
            
            MessagerManager.showMessage(title: title, message: message, theme: .error, view: self.view)
            return
        }
        
        
        AuthorizationManager.registration(userName: name, eMail: eMail, password: password) { (error) in
            if let error = error  {
                MessagerManager.showMessage(title: "Error", message: error, theme: .error, view: self.view)
                return
            }
            
            MessagerManager.showMessage(title: "Success", message: "", theme: .success, view: self.view)
            
           // self.performSegue(withIdentifier: "showUsers", sender: nil)
        }

    }
 
    
}
