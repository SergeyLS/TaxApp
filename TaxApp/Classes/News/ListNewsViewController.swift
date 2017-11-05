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
    @IBOutlet weak var backViewUI: UIView!
    
    var isSearch: Bool = false
    var isArhiv: Bool = false
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
        
        backViewUI.isHidden = true
        
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
                if isArhiv {
                     arrayPredicate.append(NSPredicate(format: "isArhiv = true"))
                } else {
                    if menu != nil {
                        arrayPredicate.append(NSPredicate(format: "menu = %@", menu!))
                    }
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
        SyncManager.syncArticles(view: view)
        
        if let sections = fetchController.sections,
            sections.count > 0 {
            let sectionInfo = sections[0]
            let resultNumber = sectionInfo.numberOfObjects
            if resultNumber == 0 {
                backViewUI.isHidden = false
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
        
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        //SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuWidth = view.layer.bounds.width * 0.8 //80%
        SideMenuManager.menuEnableSwipeGestures = true
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
        if isArhiv == true {
            navigationItem.title = NSLocalizedString("Архив", comment: "ListNewsViewController - navigationItem.title")
            return
        }
        
        if menu == nil && isArhiv == false {
            navigationItem.title = NSLocalizedString("Все новости", comment: "ListNewsViewController - navigationItem.title")
            AppDataManager.shared.currentMenu = ""
        } else {
            navigationItem.title = menu?.title
        }
    }
    
    //==================================================
    // MARK: - action
    //==================================================
    @objc func myRightSideBarButtonItemTapped(gesture: UIGestureRecognizer) {
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
        
        if (segue.identifier == "openWeb") {
            let destinationController = segue.destination as! WebViewViewController
            destinationController.article = sender as! Article
        }
        
        if (segue.identifier == "newMessage") {
            let destinationController = segue.destination as! ViewMessageViewController
            if let articleTemp =  sender as? Article  {
                destinationController.textMessage = "Сообщение к статье: '\(String(describing: (articleTemp.title!) ))' \n"
            }
        }
    }
    
}


//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================
extension ListNewsViewController {
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        let sectionCount = (fetchController.sections != nil) ? fetchController.sections!.count : 0
//
////        if sectionCount == 0 {
////             backViewUI.isHidden = false
////        }
//        return sectionCount
//    }

    //MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         self.backViewUI.isHidden = true
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListNewsTableViewCell
        let article = fetchController.object(at: indexPath) as! Article
        
        cell.article = article
        cell.mainView = view
        cell.topController = self
        
        cell.titleUI.text = article.title
        cell.descriptUI.text = article.shortDescr
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
        
        cell.photoUI.image = UIImage()
        cell.indicatorUI.startAnimating()
        DispatchQueue.main.async {
            ArticleManager.getImage(article: article, width: Int(cell.photoUI.layer.bounds.width), height: Int(cell.photoUI.layer.bounds.height)) { (image) in
                cell.photoUI.image = image
                cell.indicatorUI.stopAnimating()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = fetchController.object(at: indexPath) as! Article
        
        if article.isCanOpen {
            self.performSegue(withIdentifier: "fullText", sender: article)
        } else {
            MessagerManager.showMessage(title: "", message: "Данная статья требует покупки!", theme: .error)
        }
        
    }
    
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
        backViewUI.isHidden = true
        isArhiv = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        backViewUI.isHidden = true
        isArhiv = false
        if let searchText = searchBar.text {
            searchString = searchText
        }
        
        if searchString.characters.count < 3 {
            MessagerManager.showMessage(title: "", message: "Поиск корректно работает от 3-х букв!", theme: .warning)
        }
        
        searchBar.endEditing(true)
        fetchController = nil
        performFetch()
        reloadData()
        
        ArticleManager.getArticleSearchFromAPI(search: searchString) { (errorArticle) in
            if let error = errorArticle  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error)
                return
            }
            
            if let sections = self.fetchController.sections,
                sections.count > 0 {
                let sectionInfo = sections[0]
                if sectionInfo.numberOfObjects == 0 {
                    self.backViewUI.isHidden = false
                 }
            }
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        // do your thing..
        
    }
}
