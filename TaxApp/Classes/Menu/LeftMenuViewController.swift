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
    @IBOutlet weak var fonUI: UIImageView!
    
    let nameEnglishMenu = "English with Tax App"
    let nameArhivMenu = "Архив"
    var rowsCount = 0
    var isArhiv = false
    
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
        configTheme()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        fonUI.image = ThemeManager.shared.findImage(name: "menuFon", themeApp: ThemeManager.shared.currentTheme())
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
    // MARK: - Action
    //==================================================
    @IBAction func homeAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "openNews", sender: nil)
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
        SyncManager.syncMenu(view: view)
    }
    
    
    //==================================================
    // MARK: - Navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "openNews") {
            let destinationController = segue.destination as! ListNewsViewController
            destinationController.menu = sender as? Menu
            destinationController.isArhiv =  isArhiv
            
        }
    }
    
}



//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================
extension LeftMenuViewController {
    
    func countObject(section: Int) -> Int {
        if let sections = fetchController.sections,
            sections.count > 0  {
            return sections[section].numberOfObjects
        }
        return 0
        
    }
    
    //MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var resultNumber: Int = 0
        if let sections = fetchController.sections,
            sections.count > section {
            let sectionInfo = sections[section]
            resultNumber = sectionInfo.numberOfObjects
        }
        rowsCount = resultNumber + 2
        return rowsCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeftMenuTableViewCell
        let rowNumber = indexPath.row + 1
        var menuTitle = ""
        
        
        cell.nextImageUI.image = ThemeManager.shared.findImage(name: "menuTableNext", themeApp: ThemeManager.shared.currentTheme())
        
        if rowNumber <= countObject(section: indexPath.section) {
            let menu = fetchController.object(at: indexPath) as! Menu
            menuTitle = menu.title!
            
            cell.nameUI.text = menuTitle
            cell.nameUI.textColor =  UIColor(hex: "4D4D4D")
        } else {
            if rowNumber == rowsCount {
                menuTitle = nameArhivMenu
                cell.nameUI.text = menuTitle
                cell.nameUI.textColor = UIColor.black
                
            } else {
                menuTitle = nameEnglishMenu
                cell.nameUI.text = menuTitle
                cell.nameUI.textColor = UIColor.red
            }
        }
        
        if menuTitle == AppDataManager.shared.currentMenu {
            cell.nextImageUI.isHidden = false
        } else {
            cell.nextImageUI.isHidden = true
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowNumber = indexPath.row + 1
        if rowNumber <= countObject(section: indexPath.section) {
            let menu = fetchController.object(at: indexPath) as! Menu
            isArhiv = false
            self.performSegue(withIdentifier: "openNews", sender: menu)
            AppDataManager.shared.currentMenu = menu.title!
        } else {
            if rowNumber == rowsCount {
                isArhiv = true
                self.performSegue(withIdentifier: "openNews", sender: true)
                AppDataManager.shared.currentMenu = nameArhivMenu
                reloadData()
            } else {
                self.performSegue(withIdentifier: "openEnglish", sender: nil)
                AppDataManager.shared.currentMenu = nameEnglishMenu
                reloadData()
            }
        }
        
    }
    
}



