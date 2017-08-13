//
//  MessageViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/12/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class MessageViewController: BaseImageViewController {

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
        
        navigationItem.title = NSLocalizedString("Сообщения", comment: "MessageViewController - navigationItem.title")
        configTheme()
        tableView.reloadData()
    }

    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        fonUI.image = ThemeManager.shared.findImage(name: "messageFon", themeApp: ThemeManager.shared.currentTheme())
    }

    

}



//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================

extension MessageViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "messageInbox", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Входящие"
            cell.countUI.setTitle("100", for: .normal)
            cell.countUI.isHidden = false
            cell.reloadData()
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "messageSent", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Отправленные"
            cell.countUI.setTitle("", for: .normal)
            cell.countUI.isHidden = true
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "messageTrash", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Корзина"
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
//        let row = indexPath.row
//        switch row {
//        case 2:
//            AppDataManager.shared.userLogin = ""
//            self.performSegue(withIdentifier: "exitUser", sender: nil)
//        default:
//            return
//        }
    }
}
