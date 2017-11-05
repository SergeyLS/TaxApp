//
//  EditProfileViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/16/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseImageViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fonUI: UIImageView!
    @IBOutlet weak var saveButtonUI: UIButton!
    
    var firstName: String = ""
    var lastName: String = ""
    var category: Category?
    
    var activeTextField: UITextField?
    private var contentInsets: UIEdgeInsets?
    
    var user: User!
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = AppDataManager.shared.currentUser
        photoUI.layer.cornerRadius = photoUI.bounds.size.height / 2
        photoUI.image = user.photoImage
        firstName = user.firstName ?? ""
        lastName = user.lastName ?? ""
        category = user.category
        
        //image tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        photoUI.addGestureRecognizer(tapGesture)
        photoUI.isUserInteractionEnabled = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if photoUI.image == nil {
            photoUI.image = UIImage(named: "userNoPhoto")
        }
        
        configTheme()
        
        
        CategoryManager.getCategoryFromAPI() { (error) in
            if let error = error  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error)
                return
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = NSLocalizedString("Личный кабинет", comment: "EditProfileViewController - navigationItem.title")
        configTheme()
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        fonUI.image = ThemeManager.shared.findImage(name: "editProfileFon", themeApp: ThemeManager.shared.currentTheme())
        tableView.reloadData()
        saveButtonUI.backgroundColor = ThemeManager.shared.mainColor()
        configButton(button: saveButtonUI)
    }
    
    
    //==================================================
    // MARK: - Action
    //==================================================
    
    
    @IBAction func editingChangedAction(_ sender: UITextField) {
        switch sender.tag {
        case 1:
            firstName = sender.text!
        case 2:
            lastName = sender.text!
        default:
            return
        }
        
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        if  firstName == "" || lastName == "" || category == nil {
            let title = NSLocalizedString("Ошибка!", comment: "LoginViewController")
            let message = NSLocalizedString("Не заполнены все обязательные поля!", comment: "LoginViewController")
            
            MessagerManager.showMessage(title: title, message: message, theme: .error)
            return
        }
        
        loadingPlaceholderViewHidden = false
        
        UserManager.postUserPhotoAPI(userName: AppDataManager.shared.userLogin,
                                     photoImage: photoUI.image!) { (errorPhoto) in
                                        if let error = errorPhoto  {
                                            MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error)
                                            self.loadingPlaceholderViewHidden = true
                                            return
                                        }
                                        
                                        
                                        UserManager.patchUserAPI(firstName: self.firstName,
                                                                 lastName: self.lastName,
                                                                 category: self.category!) { (errorUser) in
                                                                    
                                                                    self.loadingPlaceholderViewHidden = true
                                                                    if let error = errorUser  {
                                                                        MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error)
                                                                        return
                                                                    }
                                                                    
                                                                    if let user = AppDataManager.shared.currentUser {
                                                                        user.firstName  = self.firstName
                                                                        user.lastName = self.lastName
                                                                        user.photo = ImageManager.imageToDataAndResize(image: self.photoUI.image, newWidth: 300)
                                                                        user.category = self.category
                                                                        CoreDataManager.shared.saveContext()
                                                                    }
                                                                    
                                                                    MessagerManager.showMessage(title: "Изменения сохранены!", message: "", theme: .success)
                                        }
        }
    }
    
    //==================================================
    // MARK: - keyboard
    //==================================================
    func keyboardWasShown(notification: NSNotification){
        let userInfo = notification.userInfo!
        if let textFieldFrame = activeTextField?.frame,
            let keyboardRect = ((userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) {
            
            let textFieldRect = tableView.convert(textFieldFrame, to: view.window)
            let offset = textFieldRect.maxY - keyboardRect.minY + 50
            if contentInsets == nil {
                contentInsets = tableView.contentInset
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentInset.bottom = self.contentInsets!.bottom + keyboardRect.height
                if offset > 0 {
                    self.tableView.contentOffset.y += offset
                }
            })
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        UIView.animate(withDuration: 0.3, animations: {
            if let insets = self.contentInsets {
                self.tableView.contentInset = insets
                self.contentInsets = nil
            }
        })
    }
    
    
    //==================================================
    // MARK: - Navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "selectCategory") {
            let destinationController = segue.destination as! SelectCategoryViewController
            destinationController.topController = self
        }
        
    }
    
}


//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================

extension EditProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellField", for: indexPath) as! BaseFieldTableViewCell
            cell.nameUI.text = "Имя"
            cell.fieldUI.text = firstName
            cell.fieldUI.placeholder = "Введите имя"
            cell.fieldUI.textColor = ThemeManager.shared.mainColor()
            cell.fieldUI.delegate = self
            cell.fieldUI.tag = 1
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellField", for: indexPath) as! BaseFieldTableViewCell
            cell.nameUI.text = "Фамилия"
            cell.fieldUI.text = lastName
            cell.fieldUI.placeholder = "Введите фамилию"
            cell.fieldUI.textColor = ThemeManager.shared.mainColor()
            cell.fieldUI.delegate = self
            cell.fieldUI.tag = 2
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellName", for: indexPath) as! BaseLabelTableViewCell
            cell.nameUI.text = "Специализация"
            cell.selectUI.text = category?.title ?? "?"
            cell.selectUI.textColor = ThemeManager.shared.mainColor()
            return cell
            
            
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
    
    //MARK: UITableViewDelegate
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 2:
            self.performSegue(withIdentifier: "selectCategory", sender: nil)
        default:
            return
        }
    }
}


//==================================================
// MARK: - UITextFieldDelegate
//==================================================
extension EditProfileViewController {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeTextField = nil
        
        
    }
    
}

