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
    
    lazy var searchBar:UISearchBar = UISearchBar()
    lazy var barButtonItemSearch:UIBarButtonItem =  UIBarButtonItem()
    
    var isSearch: Bool = false
    var searchString: String = ""
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.frame = CGRect(x: 0, y: 0, width: view.layer.bounds.width - 80, height: 20)
        searchBar.placeholder = "Поиск..."
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.tintColor = ThemeManager.shared.mainColor()
        for subview in searchBar.subviews[0].subviews {
            if let cancelButton = subview as? UIButton{
                cancelButton.setTitleColor(UIColor.white, for: .normal)
            }
        }
        barButtonItemSearch = UIBarButtonItem(customView:searchBar)
        
        
        
        configSideMenu()
        changeRightBarButton()
        // configFetchController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isSearch {
            isSearch = false
            searchString = ""
            fetchController = nil
            performFetch()
            reloadData()
        }
        
        changeTitleNavigation()
        changeRightBarButton()
        configTheme()
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
                if searchString != "" {
                    arrayPredicate.append(NSPredicate(format: "forSearch CONTAINS[cd] %@", searchString))
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
        print("[ListNewsViewController] - requestData")
        
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
    func configTheme()  {
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.mainColor()
    }
    
    
    func configSideMenu()  {
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuWidth = view.layer.bounds.width * 0.8 //80%
    }
    
    func changeRightBarButton()  {
        
        if isSearch {
            self.navigationItem.rightBarButtonItem = self.barButtonItemSearch
            self.navigationItem.title = ""
        } else {
            
            let buttonIcon = UIImage(named: "buttonSearch")
            let barButtonItemImage = UIBarButtonItem(title: "",
                                                     style: UIBarButtonItemStyle.done,
                                                     target: self,
                                                     action: #selector(ListNewsViewController.myRightSideBarButtonItemTapped(gesture:)))
            barButtonItemImage.image = buttonIcon
            self.navigationItem.rightBarButtonItem = barButtonItemImage
            self.changeTitleNavigation()
        }
    }
    
    func changeTitleNavigation()  {
        if menu == nil {
            navigationItem.title = NSLocalizedString("Все новости", comment: "ListNewsViewController - navigationItem.title")
            AppDataManager.shared.currentMenu = ""
        } else {
            navigationItem.title = menu?.title
        }
    }
    
    //==================================================
    // MARK: - action
    //==================================================
    func myRightSideBarButtonItemTapped(gesture: UIGestureRecognizer) {
        isSearch = true
        changeRightBarButton()
        searchBar.becomeFirstResponder()
    }
    
    
    
    //==================================================
    // MARK: - Navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "fullText") {
            let destinationController = segue.destination as! DetailNewsViewController
            destinationController.article = sender as! Article
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
        cell.likeButtonUI.setTitle(" " + String(article.likes), for: .normal)
        
        if article.price > 0 {
            cell.payButtonUI.setTitle(" " + String(article.price), for: .normal)
        } else {
            cell.payButtonUI.setTitle(" free", for: .normal)
        }
        
        
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
        
        if article.isCanOpen {
            self.performSegue(withIdentifier: "fullText", sender: article)
        } else {
            MessagerManager.showMessage(title: "", message: "Данная статья требует покупки!", theme: .error, view: self.view)
        }
        
    }
    
   
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    //
    //    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
}


//==================================================
// MARK: - UISearchResultsUpdating
//==================================================
extension ListNewsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        menu = nil
        changeRightBarButton()
        searchString = ""
        fetchController = nil
        performFetch()
        reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchString = searchText
        }
        
        if searchString.characters.count < 4 {
            MessagerManager.showMessage(title: "", message: "Поиск корректно работает от 4-х букв!", theme: .warning, view: self.view)
        }
        
        searchBar.endEditing(true)
        fetchController = nil
        performFetch()
        reloadData()
        
        ArticleManager.getArticleSearchFromAPI(search: searchString) { (errorArticle) in
            if let error = errorArticle  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.view)
                return
            }
            
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        // do your thing..
        
    }
}
