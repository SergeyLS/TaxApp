//
//  NewMessageViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/29/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class NewMessageViewController: BaseViewController {
    
    @IBOutlet weak var mainButtonUI: UIButton!
    @IBOutlet weak var dateUI: UILabel!
    @IBOutlet weak var messageUI: UILabel!
    @IBOutlet weak var lineUI: UILabel!
    @IBOutlet weak var textUI: UITextView!
    @IBOutlet weak var deleteUI: UIBarButtonItem!
    
    var messageMain: Message?
    var date = Date()
    var textMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configButton(button: mainButtonUI, isMakeCircle: true, isShadow: true)
        
        if messageMain == nil {
            deleteUI.isEnabled = false
        }
        
        textUI.addDoneButtonToKeyboard(myAction:  #selector(textUI.resignFirstResponder))
        
        if let message = messageMain  {
            
            if message.kind == MessageKind.delete.rawValue {
                deleteUI.isEnabled = false
                mainButtonUI.isHidden = true
                textUI.isHidden = true
            }
            if message.kind == MessageKind.sent.rawValue {
                mainButtonUI.isHidden = true
                textUI.isHidden = true
            }

            if message.isNew {
               message.isNew = false
               CoreDataManager.shared.saveContext()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if messageMain == nil {
            navigationItem.title = "Письмо администратору"
        } else {
            navigationItem.title = "Ваш ответ"
        }
        textUI.text = ""
        textUI.layer.cornerRadius = 5
        configTheme()
        reloadData()
        
        if messageMain == nil {
            textUI.becomeFirstResponder()
        }
    }
    
    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.mainColor()
        mainButtonUI.backgroundColor = ThemeManager.shared.mainColor()
        lineUI.backgroundColor = ThemeManager.shared.mainColor()
    }
    
    func reloadData()  {
        if messageMain == nil {
            date = Date()
            textMessage = "Новое сообщение для администратора"
        } else {
            date = (messageMain?.dateUpdate)!
            textMessage = (messageMain?.text)!
        }
        
        dateUI.text = DateManager.dateAndTimeToString(date: date)
        messageUI.text = textMessage
    }
    
    
    //==================================================
    // MARK: - action
    //==================================================
    @IBAction func sendMessage(_ sender: UIButton) {
        
        if  textUI.text == "" {
            let title = NSLocalizedString("Ошибка!", comment: "LoginViewController")
            let message = NSLocalizedString("Не заполнены все обязательные поля!", comment: "LoginViewController")
            
            MessagerManager.showMessage(title: title, message: message, theme: .error, view: self.view)
            return
        }
        
        loadingPlaceholderViewHidden = false
        
        MessageManager.sendMessage(adminMessage: messageMain, text: textUI.text) { (error) in
            if let error = error  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.view)
                self.loadingPlaceholderViewHidden = true
                return
            }
            
            self.loadingPlaceholderViewHidden = true
            MessagerManager.showMessage(title: "Сообщение отправлено!", message: "", theme: .success, view: self.view)
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    
    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        
        let alert:UIAlertController=UIAlertController(title: NSLocalizedString("Удалить сообщение?", comment: "NewMessageViewController - UIAlertController"), message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.view.tintColor = ThemeManager.shared.mainColor()
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)   { UIAlertAction in
            
            if let message = self.messageMain {
                message.kind = MessageKind.delete.rawValue
                CoreDataManager.shared.saveContext()
                self.navigationController!.popViewController(animated: true)
            }
            
            
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)   { UIAlertAction in
            return
            
        }
        
        // Add the actions
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
