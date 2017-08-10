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
            navigationItem.title = NSLocalizedString("Все новости", comment: "ListNewsViewController - navigationItem.title")
            AppDataManager.shared.currentMenu = ""
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
                
                let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                var arrayPredicate:[NSPredicate] = []
                if menu != nil {
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
            
            ArticleManager.getArticleFromAPI() { (errorArticle) in
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
        SideMenuManager.menuWidth = view.layer.bounds.width * 0.8 //80%
    }
    
    //==================================================
    // MARK: - action
    //==================================================
    
    
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
        
        cell.article = article
        cell.mainView = view
        
        cell.titleUI.text = article.title
        cell.descriptUI.text = article.shortDescr
        cell.photoUI.image = article.photoImage
        cell.nameMenuUI.text = article.menu?.title
        if let date  = article.dateCreated {
            cell.dateUI.text = DateManager.dateToString(date: date)
        } else {
            cell.dateUI.text = ""
        }
        
        
        if article.isLike {
            cell.likeButtonUI.setImage(UIImage(named: "buttonLikeOn"), for: .normal)
        } else {
            cell.likeButtonUI.setImage(UIImage(named: "buttonLike"), for: .normal)
        }
        
        //        cell.indicatorUI.startAnimating()
        //
        //        DispatchQueue.main.async {
        //            ArticleManager.getImage(article: article, completion: { (image) in
        //                cell.photoUI.image = image
        //                cell.indicatorUI.stopAnimating()
        //              })
        //        }
        
        if article.photoImage == nil {
            cell.indicatorUI.startAnimating()
            ArticleManager.getImage(article: article) {_ in }
        } else {
            cell.photoUI.image = article.photoImage
            cell.indicatorUI.stopAnimating()
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = fetchController.object(at: indexPath) as! Article
        self.performSegue(withIdentifier: "openWeb", sender: article)
    }
    
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    //
    //    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
}

