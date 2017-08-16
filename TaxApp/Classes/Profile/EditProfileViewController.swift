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

    var firstName: String = ""
    var lastName: String = ""
    
    var user: User!
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()

        user = AppDataManager.shared.currentUser
        
        photoUI.layer.cornerRadius = photoUI.bounds.size.height / 2

        //image tap
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
                photoUI.addGestureRecognizer(tapGesture)
                photoUI.isUserInteractionEnabled = true
        
        tableView.delegate = self
        tableView.dataSource = self
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
    }


    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        fonUI.image = ThemeManager.shared.findImage(name: "editProfileFon", themeApp: ThemeManager.shared.currentTheme())
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
        return 2
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellField", for: indexPath) as! BaseFieldTableViewCell
            cell.nameUI.text = "Имя"
            cell.fieldUI.text = user.firstName
            return cell
  
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellField", for: indexPath) as! BaseFieldTableViewCell
            cell.nameUI.text = "Фамилия"
            cell.fieldUI.text = user.lastName
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
//        case 0:
//            self.performSegue(withIdentifier: "message", sender: nil)
//        default:
//            return
//        }
    }
}
