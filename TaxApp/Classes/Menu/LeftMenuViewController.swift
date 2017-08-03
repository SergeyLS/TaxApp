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

        photoUI.layer.cornerRadius = photoUI.bounds.size.height / 2
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
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptor]
                fetchRequest.predicate = NSPredicate(format: "isMyFamily = true")
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
}



//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================
extension LeftMenuViewController {
    //MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeftMenuTableViewCell
        
        return cell
    }
    
    
}
