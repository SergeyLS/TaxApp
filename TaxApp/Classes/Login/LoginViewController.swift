//
//  LoginViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/1/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

import FacebookCore
import FacebookLogin

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
        
        configButton(button: facebookButtonUI)
        configButton(button: twitterButtonUI)
        configButton(button: googleButtonUI)
        configButton(button: enterButtonUI)
        configButton(button: nextButtonUI)
        configButton(button: signUpButtonUI)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    //==================================================
    // MARK: - action
    //==================================================
    @IBAction func nextAction(_ sender: UIButton) {
        AppDataManager.shared.userLogin = User.noLoginUserKey
        
        
        if UserManager.getUserByLogin(login: User.noLoginUserKey) != nil  {
            self.performSegue(withIdentifier: "openNews", sender: nil)
        } else {
            // New
            guard let user = User(userName: User.noLoginUserKey)   else {
                print("Error: Could not create a new default User.")
                return
            }
            user.firstName = "Гость"
            CoreDataManager.shared.saveContext()
            self.performSegue(withIdentifier: "openNews", sender: nil)
        } //else
    }
    
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
            
            UserManager.getUserFromAPI(token: AppDataManager.shared.userToken) { (errorUser) in
                if let error = errorUser  {
                    MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.view)
                    return
                }
                
                if AppDataManager.shared.currentUser != nil {
                    UserManager.getUserAvatarFromAPI(token: AppDataManager.shared.userToken) { (errorAvatar) in
                        if errorAvatar != nil {
                            print(errorAvatar!)
                            return
                        }
                    }
                }
                
                MessagerManager.showMessage(title: "Success", message: "", theme: .success, view: self.view)
                self.performSegue(withIdentifier: "openNews", sender: nil)
            }
        }
        
    }
    
    
    @IBAction func facebookAction(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
//                print("Logged into Facebook")
//                print(grantedPermissions)
//                print(declinedPermissions)
//                // Save Facebook info in cookies
//                let defaults = UserDefaults.standard
//                defaults.set(accessToken.authenticationToken, forKey: "facebookAuthenticationToken")
//                defaults.set(accessToken.userId, forKey: "facebookUserID")
                AuthorizationManager.login(socialNetwork: .facebook, userId: accessToken.userId!) { (error) in
                    if let error = error  {
                        MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.view)
                        return
                    }

                    
                }
            }
        }
    }
    
    
}
