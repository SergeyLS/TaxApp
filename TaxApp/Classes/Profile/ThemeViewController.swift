//
//  ThemeViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/13/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ThemeViewController: BaseImageViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fonUI: UIImageView!
    
    let currentTheme = ThemeManager.shared.currentTheme()

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
        
        navigationItem.title = NSLocalizedString("Настройки темы", comment: "SettingViewController - navigationItem.title")
    }


    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        fonUI.image = ThemeManager.shared.findImage(name: "themeFon", themeApp: currentTheme)
    }

}



//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================

extension ThemeViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ThemeTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "themeCup", themeApp: currentTheme)
            cell.nameUI.text = "Доброе утро"
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ThemeTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "themeSun", themeApp: currentTheme)
            cell.nameUI.text = "Рабочий день"
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ThemeTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "themeMoon", themeApp: currentTheme)
            cell.nameUI.text = "Ночь"
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
