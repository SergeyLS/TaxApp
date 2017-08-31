//
//  BaseFetchTableViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/3/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class BaseFetchTableViewController: BaseFetchViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc internal override func reloadData() {
        super.reloadData()
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        tableView.reloadData()
        CATransaction.commit()
        
        
    }
}

//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================

extension BaseFetchTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchController.sections != nil) ? fetchController.sections!.count : 0
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var resultNumber: Int = 0
        if let sections = fetchController.sections, sections.count > section {
            let sectionInfo = sections[section]
            resultNumber = sectionInfo.numberOfObjects
        }
        return resultNumber
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "None", for: indexPath)
        assert(false, "Subclasses must override the method")
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//==================================================
// MARK: - BaseFetchTableViewController
//==================================================

extension BaseFetchTableViewController {
    final override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //        print("[BaseFetchTableVC] controllerWillChangeContent:")
        tableView.beginUpdates()
    }
    
    final override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        //        print("[BaseFetchTableVC] controller:didChange:atSectionIndex[\(String(describing: sectionIndex))]:for[\(String(describing: type))]")
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    final override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            //            print("[BaseFetchTableVC] controller:didChange:at[\(String(describing: indexPath))]:for[insert]:newIndexPath[\(String(describing: newIndexPath))]:")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            //            print("[BaseFetchTableVC] controller:didChange:at[\(String(describing: indexPath))]:for[delete]:newIndexPath[\(String(describing: newIndexPath))]:")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            //            print("[BaseFetchTableVC] controller:didChange:at[\(String(describing: indexPath))]:for[update]:newIndexPath[\(String(describing: newIndexPath))]:")
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            //            print("[BaseFetchTableVC] controller:didChange:at[\(String(describing: indexPath))]:for[move]:newIndexPath[\(String(describing: newIndexPath))]:")
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //        print("[BaseFetchTableVC] controllerDidChangeContent:")
        tableView.endUpdates()
    }
}
