//
//  ChangePassword.swift
//  TaxApp
//
//  Created by Sergey on 01.09.17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ChangePassword: BaseImageViewController  {
    //==================================================
    // MARK: - Properties
    //==================================================
    @IBOutlet weak var fonUI: UIImageView!
    @IBOutlet weak var fieldsMainView: UIView!
    @IBOutlet weak var oldPassField: UITextField!
    @IBOutlet weak var newPassField: UITextField!
    @IBOutlet weak var retryNewPassField: UITextField!
    @IBOutlet weak var changePassButton: UIButton!
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
    @IBOutlet weak var bottomMainViewConstraint: NSLayoutConstraint!

    //==================================================
    // MARK: - LifeCicle
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        configTheme()
        configView()
        configObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = NSLocalizedString("Сменить пароль", comment: "ChangePasswordViewController - navigationItem.title")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //==================================================
    // MARK: - Configuration
    //==================================================
    func configTheme() {
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.mainColor()
        oldPassField.textColor = ThemeManager.shared.mainColor()
        newPassField.textColor = ThemeManager.shared.mainColor()
        retryNewPassField.textColor = ThemeManager.shared.mainColor()
        changePassButton.setTitleColor(ThemeManager.shared.mainColor(), for: .normal)
        loadingActivityView.tintColor = ThemeManager.shared.mainColor()
        changePassButton.layer.borderColor = ThemeManager.shared.mainColor().cgColor
        fonUI.image = ThemeManager.shared.findImage(name: "changePasswordFon", themeApp: ThemeManager.shared.currentTheme())
    }
    
    func configView() {
        oldPassField.layer.cornerRadius = 4;
        newPassField.layer.cornerRadius = 4;
        retryNewPassField.layer.cornerRadius = 4;
        changePassButton.layer.cornerRadius = 4;
        changePassButton.layer.borderWidth = 1;
    }
    
    func configObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    //==================================================
    // MARK: - Actions
    //==================================================
    @IBAction func changePassButton(_ sender: UIButton) {
        if let user = AppDataManager.shared.currentUser  {
            let title = NSLocalizedString("Ошибка!", comment: "messageNoLogin")
            var message = ""
            if newPassField.text != retryNewPassField.text {
                message = NSLocalizedString("Пароли не совпадают.", comment: "passNotMatch")
            }else if ((newPassField.text?.length)! < 6 || (retryNewPassField.text?.length)! < 6) {
                message = NSLocalizedString("Пароль должен содержать минимум 6 символов.", comment: "passMin6Char")
            }else if (oldPassField.text?.length)! < 1 {
                message = NSLocalizedString("Укажите старый пароль.", comment: "enterOldPass")
            }else if oldPassField.text != user.password {
                message = NSLocalizedString("Старый пароль не верен!", comment: "oldPassNotValid")
            }
            
            if message.length > 0 {
                MessagerManager.showMessage(title: title, message: message, theme: .error, view: view)
                return;
            }
            
            loadingActivityView.startAnimating()
            changePassButton.setTitle("", for: .normal)
            view.isUserInteractionEnabled = false
            
            self.view.endEditing(true);
            UserManager.patchUserPasswordAPI(password: newPassField.text!) { (errorUser) in
                
                self.loadingActivityView.stopAnimating()
                self.changePassButton.setTitle(NSLocalizedString("Сменить", comment: "change"), for: .normal)
                self.view.isUserInteractionEnabled = true
                
                if let error = errorUser  {
                    MessagerManager.showMessage(title: NSLocalizedString("Ошибка!", comment: "error"), message: error, theme: .error, view: self.view)
                    return
                }
                user.password  = self.newPassField.text
                CoreDataManager.shared.saveContext()
                MessagerManager.showMessage(title: NSLocalizedString("Пароль изменен!", comment: "passwordChanged"), message: "", theme: .success, view: self.view)
                self.oldPassField.text = ""
                self.newPassField.text = ""
                self.retryNewPassField.text = ""
            }
        }else {
            MessagerManager.showMessage(title: NSLocalizedString("Вы не авторизированы!", comment: "notLogin"), message: "", theme: .success, view: self.view)
        }
    }
    
    //==================================================
    // MARK: - NotificationCenter
    //==================================================
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomMainViewConstraint?.constant = 8.0
            } else {
                self.bottomMainViewConstraint?.constant = endFrame?.size.height ?? 8.0
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: { self.view.layoutIfNeeded() },completion: nil)
        }
    }
    
    //==================================================
    // MARK: - UITextFieldDelegate
    //==================================================
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPassField {
            newPassField.becomeFirstResponder()
        }else if textField == newPassField {
            retryNewPassField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return false
    }
}
