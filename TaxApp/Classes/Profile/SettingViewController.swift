//
//  SettingViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/12/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class SettingViewController: BaseImageViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fonUI: UIImageView!
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configTheme()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = NSLocalizedString("Настройки", comment: "SettingViewController - navigationItem.title")
        configTheme()
        tableView.reloadData()
    }
    
    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        fonUI.image = ThemeManager.shared.findImage(name: "settingFon", themeApp:ThemeManager.shared.currentTheme())
    }
    
}



//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "settingCabinet", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Личный кабинет"
            cell.countUI.setTitle("", for: .normal)
            cell.countUI.isHidden = true
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "settingThema", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Настройки темы"
            cell.countUI.setTitle("", for: .normal)
            cell.countUI.isHidden = true
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "settingConf", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Конфиденциальность"
            cell.countUI.setTitle("", for: .normal)
            cell.countUI.isHidden = true
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "settingPassword", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Сменить пароль"
            cell.countUI.setTitle("", for: .normal)
            cell.countUI.isHidden = true
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "settingAbout", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "О программе"
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
            self.performSegue(withIdentifier: "editProfile", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "theme", sender: nil)
        default:
            return
        }
    }
}
