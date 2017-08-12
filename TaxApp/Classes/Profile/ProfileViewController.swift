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
    
    let currentTheme = ThemeManager.shared.currentTheme()
    
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoUI.layer.cornerRadius = photoUI.bounds.size.height / 2
        //image tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
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
    }
    
    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        fonUI.image = ThemeManager.shared.findImage(name: "profileFon", themeApp: currentTheme)
        nameUI.textColor = ThemeManager.shared.mainColor()
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
        return 3
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "profileMail", themeApp: currentTheme)
            cell.nameUI.text = "Сообщения"
            cell.countUI.setTitle("2", for: .normal)
            cell.countUI.isHidden = false
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "profileSetting", themeApp: currentTheme)
            cell.nameUI.text = "Настройки"
            cell.countUI.setTitle("", for: .normal)
            cell.countUI.isHidden = true
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "profileExit", themeApp: currentTheme)
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
            self.performSegue(withIdentifier: "message", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "setting", sender: nil)
        case 2:
            AppDataManager.shared.userLogin = ""
            self.performSegue(withIdentifier: "exitUser", sender: nil)
        default:
            return
        }
    }
}

