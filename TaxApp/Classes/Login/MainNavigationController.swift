//
//  MainNavigationController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/5/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    var splashViewController: UIViewController {
        get {
            return (self.storyboard?.instantiateViewController(withIdentifier: "splashStoryboardIdentifier"))!
        }
    }
    
    var loginViewController: UIViewController {
        get {
            return (self.storyboard?.instantiateViewController(withIdentifier: "loginStoryboardIdentifier"))!
        }
    }
    
    var newsViewController: UIViewController {
        get {
            return (self.storyboard?.instantiateViewController(withIdentifier: "newsStoryboardIdentifier"))!
        }
    }
    
    
    private var appDataManager: AppDataManager {
        return AppDataManager.shared
    }
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([splashViewController], animated:false)
        
        addObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        removeObservers()
    }
    
    //==================================================
    // MARK: - func
    //==================================================
    private func reloadData(animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                if let _ = strongSelf.appDataManager.currentUser {
                    
                    strongSelf.performSegue(withIdentifier: "openNews", sender: nil)
                    
                    //strongSelf.setViewControllers([strongSelf.loginViewController], animated:animated)
                } else {
                    strongSelf.setViewControllers([strongSelf.loginViewController], animated:animated)
                }
            }
        }
    }
    
    
    
    
    //==================================================
    // MARK: - Notifications
    //==================================================
    
    private var isObserving = false
    
    private func addObservers() {
        if !isObserving {
            isObserving = true
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        }
    }
    
    private func removeObservers() {
        if isObserving {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
            isObserving = false
        }
    }
    
    
    @objc private func applicationDidBecomeActive(_ notification: Notification) {
        reloadData(animated: false)
    }
    
    
    
}
