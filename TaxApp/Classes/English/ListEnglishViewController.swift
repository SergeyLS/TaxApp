//
//  ListEnglishViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 9/13/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import SideMenu
import CoreData

class ListEnglishViewController: BaseFetchCollectionViewController {
    
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        navigationController?.navigationBar.barTintColor = ColorManager.colorEnglish
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = NSLocalizedString("English with Tax App", comment: "ListEnglishViewController - navigationItem.title")
    }
    
    
    //==================================================
    // MARK: - Fetch Data
    //==================================================
    private var _fetchController: NSFetchedResultsController<NSFetchRequestResult>?
    
    internal override var fetchController: NSFetchedResultsController<NSFetchRequestResult>! {
        get {
            if _fetchController == nil {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MenuEnglish.fetchRequest()
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
        SyncManager.syncEnglishMenu(view: view)
    }
    
    
    
    //==================================================
    // MARK: - action
    //==================================================
    @IBAction func leftMenuAction(_ sender: UIBarButtonItem) {
        self.navigationController?.present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
}



//==============================================================
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//==============================================================
extension ListEnglishViewController {
    
    //MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListEnglishCollectionViewCell
        
        let menuEnglish = fetchController.object(at: indexPath) as! MenuEnglish
        
        cell.photoUI.image = menuEnglish.photoImage
        cell.nameUI.text = menuEnglish.title
        
        return cell
    }
    
}

