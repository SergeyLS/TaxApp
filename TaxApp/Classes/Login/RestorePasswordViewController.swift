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
    
    @IBOutlet weak var fonUI: UIImageView!
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eMailFieldUI.delegate = self
        
        configButton(button: restoreButtonUI)
        
        configTheme()
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
    // MARK: - func
    //==================================================
    func configTheme()  {
        fonUI.image = ThemeManager.shared.findImage(name: "startLogo", themeApp: ThemeManager.shared.currentTheme())
    }

    //==================================================
    // MARK: - action
    //==================================================
    @IBAction func restoreAction(_ sender: UIButton) {
        let eMail = eMailFieldUI.text!
        
        
        if eMail == "" {
            let title = NSLocalizedString("Ошибка!", comment: "Oops")
            let message = NSLocalizedString("Не заполнены все обязательные поля!", comment: "SignUpViewController - signUpAction")
            
            MessagerManager.showMessage(title: title, message: message, theme: .error)
            return
        }
        
        AuthorizationManager.resetPassword(eMail: eMail) { (error) in
            if let error = error  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error)
                return
            }
            
            let title = NSLocalizedString("Успех!", comment: "RestorePasswordViewController - title")
            let message = NSLocalizedString("Новый пароль отправлен на Ваш e-mail!", comment: "RestorePasswordViewController - message")
            MessagerManager.showMessage(title: title, message: message, theme: .success)
            
        }
        
    }
    
    
}
