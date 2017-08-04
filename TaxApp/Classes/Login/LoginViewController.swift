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
    @IBOutlet weak var nextButtonUI: UIButton!
    @IBOutlet weak var signUpButtonUI: UIButton!
    
    @IBOutlet weak var eMailFieldUI: UITextField!
    @IBOutlet weak var passwordFieldUI: UITextField!
    
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        eMailFieldUI.delegate = self
        passwordFieldUI.delegate = self
        
        congigButton(button: facebookButtonUI)
        congigButton(button: twitterButtonUI)
        congigButton(button: googleButtonUI)
        congigButton(button: enterButtonUI)
        congigButton(button: nextButtonUI)
        congigButton(button: signUpButtonUI)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
        
        
        if  password == "" || eMail == "" {
            let title = NSLocalizedString("Ошибка!", comment: "LoginViewController")
            let message = NSLocalizedString("Не заполнены все обязательные поля!", comment: "LoginViewController")
            
            MessagerManager.showMessage(title: title, message: message, theme: .error, view: self.view)
            return
        }
        
        AuthorizationManager.login(eMailOrLogin: eMail, password: password) { (error) in
            if let error = error  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.view)
                return
            }
            
            
            
            MessagerManager.showMessage(title: "Success", message: "", theme: .success, view: self.view)
            self.performSegue(withIdentifier: "openNews", sender: nil)
        }
        
    }
    
    
}
