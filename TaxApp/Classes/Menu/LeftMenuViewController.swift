//
//  LeftMenuViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/2/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class LeftMenuViewController: BaseFetchTableViewController {
    
    @IBOutlet weak var photoUI: UIImageView!
    @IBOutlet weak var nameUI: UILabel!
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        photoUI.layer.cornerRadius = photoUI.bounds.size.height / 2
        
        //image tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        photoUI.addGestureRecognizer(tapGesture)
        photoUI.isUserInteractionEnabled = true

        loadUserInfo()
      }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //==================================================
    // MARK: - func
    //==================================================
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
    // MARK: - Action
    //==================================================
    @IBAction func homeAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "openNews", sender: nil)
    }

    @IBAction func exitButton(_ sender: UIButton) {
        AppDataManager.shared.userLogin = ""
        self.performSegue(withIdentifier: "exitUser", sender: nil)
    }
    
    
    
    func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            self.performSegue(withIdentifier: "profile", sender: nil)
        }
    }
   
    //==================================================
    // MARK: - Fetch Data
    //==================================================
    private var _fetchController: NSFetchedResultsController<NSFetchRequestResult>?
    
    internal override var fetchController: NSFetchedResultsController<NSFetchRequestResult>! {
        get {
            if _fetchController == nil {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Menu.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                var arrayPredicate:[NSPredicate] = []
                if AppDataManager.shared.currentUser != nil {
                    arrayPredicate.append(NSPredicate(format: "user = %@", AppDataManager.shared.currentUser!))
                }
                
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
                
                fetchRequest.predicate = predicate
                let resultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
                resultController.delegate = self
                
                _fetchController = resultController
            }
            return _fetchController
        }
        set(newValue) {
            _fetchController = newValue
        }
    }
    
    internal override func requestData() {
        
        MenuManager.getMenuFromAPI() { (error) in
            if let error = error  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.view)
                return
            }
        }
    }
    
    
    //==================================================
    // MARK: - Navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "openNews") {
            let destinationController = segue.destination as! ListNewsViewController
            destinationController.menu = sender as? Menu
        }
    }
    
}



//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================
extension LeftMenuViewController {
    //MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeftMenuTableViewCell
        let menu = fetchController.object(at: indexPath) as! Menu
        
        if menu.title == AppDataManager.shared.currentMenu {
            cell.nextImageUI.isHidden = false
        } else {
            cell.nextImageUI.isHidden = true
        }
        
        cell.nameUI.text = menu.title
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = fetchController.object(at: indexPath) as! Menu
        AppDataManager.shared.currentMenu = menu.title!
        self.performSegue(withIdentifier: "openNews", sender: menu)
    }
    
}



