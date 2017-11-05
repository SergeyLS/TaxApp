//
//  BaseFetchViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/3/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class BaseFetchViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performFetchIfNeeded()
    }
    
    private let kBaseFetchVCDelay = 0.1
    
    internal var fetchController: NSFetchedResultsController<NSFetchRequestResult>! {
        get {
            assert(false, "Subclasses must override the method")
            return NSFetchedResultsController()
        }
        set(newValue) {
            assert(false, "Subclasses must override the method")
        }
    }
    
    public var shouldFetch: Bool = true
    public var shouldRequest: Bool = true
    public var shouldReloadData: Bool = true
    
    @objc func performFetch() {
        //        print("[BaseFetchVC] performFetch")
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        
        do {
            try fetchController.performFetch()
        } catch {
            print(error)
        }
        
        shouldReloadData = true
        reloadDataIfNeeded()
    }
    
    public func performFetchIfNeeded() {
        //        print("[BaseFetchVC] performFetchIfNeeded[\(String(describing: shouldFetch))]")
        if shouldFetch {
            shouldFetch = false
            fetchController = nil
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performFetch), object: nil)
            perform(#selector(performFetch), with: nil, afterDelay: kBaseFetchVCDelay)
        } else {
            requestDataIfNeeded()
        }
    }
    
    @objc internal func reloadData() {
        requestDataIfNeeded()
    }
    
    public func reloadDataIfNeeded() {
        //        print("[BaseFetchVC] reloadDataIfNeeded[\(String(describing: shouldReloadData)),\(String(describing: isViewLoaded)),\(String(describing: (nil != view.window)))]")
        if shouldReloadData && isViewLoaded && nil != view.window {
            shouldReloadData = false
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadData), object: nil)
            perform(#selector(reloadData), with: nil, afterDelay: kBaseFetchVCDelay)
        } else {
            requestDataIfNeeded()
        }
    }
    
    @objc internal func requestData() {
        assert(false, "Subclasses must override the method")
    }
    
    public func requestDataIfNeeded() {
        //        print("[BaseFetchVC] requestDataIfNeeded[\(String(describing: shouldRequest))]")
//        if shouldRequest {
//            shouldRequest = false
        
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(requestData), object: nil)
            perform(#selector(requestData), with: nil, afterDelay: kBaseFetchVCDelay)
//        }
    }
}

//==================================================
// MARK: - BaseFetchTableViewController
//==================================================

extension BaseFetchViewController: NSFetchedResultsControllerDelegate {
    internal func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        assert(false, "Subclasses must override the method")
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        assert(false, "Subclasses must override the method")
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        assert(false, "Subclasses must override the method")
    }
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        assert(false, "Subclasses must override the method")
    }
}
