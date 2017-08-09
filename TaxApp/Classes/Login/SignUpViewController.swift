//
//  SignUpViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/4/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var signUpButtonUI: UIButton!
    
    @IBOutlet weak var eMailFieldUI: UITextField!
    @IBOutlet weak var loginFieldUI: UITextField!
    
    @IBOutlet weak var passwordFieldUI: UITextField!
    @IBOutlet weak var password2FieldUI: UITextField!
    
    
    //==================================================
    // MARK: - General
    //==================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eMailFieldUI.delegate = self
        passwordFieldUI.delegate = self
        password2FieldUI.delegate = self
        
        configButton(button: signUpButtonUI)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = NSLocalizedString("Регистрация", comment: "SignUpViewController - navigationItem.title")
    }

    
    
    //==================================================
    // MARK: - action
    //==================================================
   
    @IBAction func signUpAction(_ sender: UIButton) {
        
        let password = passwordFieldUI.text!
        let password2 = password2FieldUI.text!
        let eMail = eMailFieldUI.text!
        let login = loginFieldUI.text!
        
        
        if login == "" || eMail == "" || password == "" || password2 == "" {
            let title = NSLocalizedString("Ошибка!", comment: "Oops")
            let message = NSLocalizedString("Не заполнены все обязательные поля!", comment: "SignUpViewController - signUpAction")
            
            MessagerManager.showMessage(title: title, message: message, theme: .error, view: self.view)
            return
        }
        
        if password  != password2 {
            let title = NSLocalizedString("Ошибка!", comment: "Oops")
            let message = NSLocalizedString("Пароли не совпадают!", comment: "SignUpViewController - signUpAction")
            
            MessagerManager.showMessage(title: title, message: message, theme: .error, view: self.view)
            return
        }
 
        
        AuthorizationManager.registration(eMail: eMail, login: login, password: password) { (error) in
            if let error = error  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.view)
                return
            }
            
            AppDataManager.shared.userLogin = login
            
            if let user = User(userName: login) {
                user.eMail = eMail
                user.lastLogin = Date()
                CoreDataManager.shared.saveContext()
                
                MessagerManager.showMessage(title: "Success", message: "", theme: .success, view: self.view)
                self.performSegue(withIdentifier: "openNews", sender: nil)
            }

            
         }
        
    }
    
    
    //==================================================
    // MARK: - navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openNews" {
        }
     }
   
}