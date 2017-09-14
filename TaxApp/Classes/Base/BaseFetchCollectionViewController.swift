//
//  BaseFetchCollectionViewController.swift
//  Shopping List
//
//  Created by Сергей Гориненко on 6/23/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class BaseFetchCollectionViewController: BaseFetchViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc internal override func reloadData() {
        super.reloadData()
        collectionView.reloadData()
    }
}

//==============================================================
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//==============================================================

extension BaseFetchCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (fetchController.sections != nil) ? fetchController.sections!.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var resultNumber: Int = 0
        if let sections = fetchController.sections, sections.count > section {
            let sectionInfo = sections[section]
            resultNumber = sectionInfo.numberOfObjects
        }
        return resultNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "None", for: indexPath)
        assert(false, "Subclasses must override the method")
        return cell
    }
    
    //MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//==================================================
// MARK: - BaseFetchTableViewController
//==================================================

extension BaseFetchCollectionViewController {
    final override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("[BaseFetchCollectionVC] reloadData: controllerWillChangeContent:")
    }
    
    final override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        //print("[BaseFetchCollectionVC] reloadData: controller:didChange:atSectionIndex:for")
//        switch type {
//        case .insert:
//            collectionView.insertSections(IndexSet(integer: sectionIndex))
//        case .delete:
//            collectionView.deleteSections(IndexSet(integer: sectionIndex))
//        case .move:
//            break
//        case .update:
//            break
//        }
    }
    
    final override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //print("[BaseFetchCollectionVC] reloadData: controller:didChange:at:for:newIndexPath:")
//        switch type {
//        case .insert:
//            collectionView.insertItems(at: [newIndexPath!])
//        case .delete:
//            collectionView.deleteItems(at: [indexPath!])
//        case .update:
//            collectionView.reloadItems(at: [indexPath!])
//        case .move:
//            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
//        }
    }
    
    final override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       // print("[BaseFetchCollectionVC] reloadData: controllerDidChangeContent:")
       reloadData()
    }
}
