//
//  ListNewsViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/2/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import SideMenu
import CoreData

class ListNewsViewController: BaseFetchTableViewController {
    
    var menu: Menu?
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configSideMenu()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if menu == nil {
            navigationItem.title = NSLocalizedString("Новости", comment: "ListNewsViewController - navigationItem.title")
        } else {
            navigationItem.title = menu?.title
        }
    }

    
    //==================================================
    // MARK: - Fetch Data
    //==================================================
    private var _fetchController: NSFetchedResultsController<NSFetchRequestResult>?
    
    internal override var fetchController: NSFetchedResultsController<NSFetchRequestResult>! {
        get {
            if _fetchController == nil {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Article.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                var arrayPredicate:[NSPredicate] = []
                if menu == nil {
                    arrayPredicate.append(NSPredicate(format: "menu = nil"))
                } else {
                    arrayPredicate.append(NSPredicate(format: "menu = %@", menu!))
                }
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
        
        MenuManager.getMenuFromAPI() { (errorMenu) in
            if let error = errorMenu  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.view)
                return
            }
            
            if self.menu == nil {
                return
            }
            
            
            
            ArticleManager.getArticleFromAPI(menu: self.menu!) { (errorArticle) in
                if let error = errorArticle  {
                    MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.view)
                    return
                }
                
            }
        }
    }
    
    //==================================================
    // MARK: - func
    //==================================================
    func configSideMenu()  {
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuWidth = view.layer.bounds.width * 0.8 //%
    }
    
    //==================================================
    // MARK: - Navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "openWeb") {
            let destinationController = segue.destination as! WebViewViewController
            if  let article = sender as? Article {
                 destinationController.link = article.link
            }
        }
        
    }

}


//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================
extension ListNewsViewController {
    //MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListNewsTableViewCell
        let article = fetchController.object(at: indexPath) as! Article
        
        cell.titleUI.text = article.title
        cell.descriptUI.text = article.shortDescr
        
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = fetchController.object(at: indexPath) as! Article
        self.performSegue(withIdentifier: "openWeb", sender: article)
    }

    
    
    
}

