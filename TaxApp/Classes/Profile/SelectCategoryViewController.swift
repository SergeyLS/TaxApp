//
//  SelectCategoryViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/17/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class SelectCategoryViewController: BaseFetchTableViewController {
    var topController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Выбор категории", comment: "SelectCategoryViewController - navigationItem.title")
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //==================================================
    // MARK: - Fetch Data
    //==================================================
    private var _fetchController: NSFetchedResultsController<NSFetchRequestResult>?
    
    internal override var fetchController: NSFetchedResultsController<NSFetchRequestResult>! {
        get {
            if _fetchController == nil {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
                
                let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
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
    
    
    override func requestData() {
    }

    
}




//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================
extension SelectCategoryViewController {
    //MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectCategoryTableViewCell
        let category = fetchController.object(at: indexPath) as! Category
        
        cell.nameUI.text = category.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = fetchController.object(at: indexPath) as! Category
        
        if let sourceController = topController as? EditProfileViewController {
            sourceController.category = category
            sourceController.tableView.reloadData()
        }
        
        navigationController!.popViewController(animated: true)
    }
    
    
}

