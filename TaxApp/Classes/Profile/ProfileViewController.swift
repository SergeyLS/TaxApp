//
//  ProfileViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/12/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ProfileViewController: BaseImageViewController {
    
    @IBOutlet weak var nameUI: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fonUI: UIImageView!
    
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoUI.layer.cornerRadius = photoUI.bounds.size.height / 2
        
        //image tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageProfileTapped(gesture:)))
        photoUI.addGestureRecognizer(tapGesture)
        photoUI.isUserInteractionEnabled = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configTheme()
        loadUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = NSLocalizedString("Мой профиль", comment: "ProfileViewController - navigationItem.title")
        configTheme()
        loadUserInfo()
     }
    
    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.mainColor()
        fonUI.image = ThemeManager.shared.findImage(name: "profileFon", themeApp: ThemeManager.shared.currentTheme())
        nameUI.textColor = ThemeManager.shared.mainColor()
        tableView.reloadData()
    }
    
    
    func loadUserInfo() {
        if let user = AppDataManager.shared.currentUser  {
            photoUI.image = user.photoImage
            if user.photoImage == nil {
                photoUI.image = UIImage(named: "userNoPhoto")
            }
            if user.fullName == " " {
                nameUI.text = user.userName
            }else {
                nameUI.text = user.fullName
            }
        } else {
            photoUI.image = UIImage(named: "userNoPhoto")
            nameUI.text = "?"
            
        }
    }
    
    //==================================================
    // MARK: - action
    //==================================================
    func imageProfileTapped(gesture: UIGestureRecognizer) {
        if AppDataManager.shared.userLogin == User.noLoginUserKey  {
            UserManager.messageNoLogin(view: view)
            return
        }
        self.performSegue(withIdentifier: "editProfile", sender: nil)

     }

    
    //==================================================
    // MARK: - Navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}


//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "profileMail", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Сообщения"
            cell.countUI.setTitle("2", for: .normal)
            cell.countUI.isHidden = false
            cell.reloadData()
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "profileSetting", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Настройки"
            cell.countUI.setTitle("", for: .normal)
            cell.countUI.isHidden = true
             return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "profileExit", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Выход"
            cell.countUI.setTitle("", for: .normal)
            cell.countUI.isHidden = true
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
        case 0:
            if AppDataManager.shared.userLogin == User.noLoginUserKey  {
                UserManager.messageNoLogin(view: view)
                return
            }
            self.performSegue(withIdentifier: "message", sender: nil)
        case 1:
            if AppDataManager.shared.userLogin == User.noLoginUserKey  {
                UserManager.messageNoLogin(view: view)
                return
            }
            self.performSegue(withIdentifier: "setting", sender: nil)
        case 2:
            AppDataManager.shared.userLogin = ""
            self.performSegue(withIdentifier: "exitUser", sender: nil)
        default:
            return
        }
    }
}

