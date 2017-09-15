//
//  SelectSubEnglishViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 9/15/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class SelectSubEnglishViewController: BaseFetchTableViewController {
    
    var menuEnglish: MenuEnglish?
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = NSLocalizedString((menuEnglish?.title)!, comment: "SelectSubEnglishViewController - navigationItem.title")
    }
    
    
    //==================================================
    // MARK: - Fetch Data
    //==================================================
    private var _fetchController: NSFetchedResultsController<NSFetchRequestResult>?
    
    internal override var fetchController: NSFetchedResultsController<NSFetchRequestResult>! {
        get {
            if _fetchController == nil {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SubMenuEnglish.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                var arrayPredicate:[NSPredicate] = []
                arrayPredicate.append(NSPredicate(format: "menuEnglish = %@", menuEnglish!))
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
    }
    
    
    //==================================================
    // MARK: - Navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "listEnglishArticles") {
            let destinationController = segue.destination as! ListEnglishArticlesViewController
            destinationController.menuEnglish = menuEnglish
            destinationController.subMenuEnglish = sender as? SubMenuEnglish
        }
    }

}


//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================
extension SelectSubEnglishViewController {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BaseFieldTableViewCell
        
        let subMenuEnglish = fetchController.object(at: indexPath) as! SubMenuEnglish
        cell.nameUI.text = subMenuEnglish.title
        
        
        return cell
        
    }
    
    //MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppDataManager.shared.userLogin == User.noLoginUserKey  {
            UserManager.messageNoLogin(view: view)
            return
        }
        
       let subMenuEnglish = fetchController.object(at: indexPath) as! SubMenuEnglish
       self.performSegue(withIdentifier: "listEnglishArticles", sender: subMenuEnglish)
    }
}


