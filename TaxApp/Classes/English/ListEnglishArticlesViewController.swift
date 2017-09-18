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

class ListEnglishArticlesViewController: BaseFetchTableViewController {
    
    var menuEnglish: MenuEnglish?
    var tempMenuEnglish: MenuEnglish?
    var subMenuEnglish: SubMenuEnglish?
    
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
    }
    
    
    //==================================================
    // MARK: - Fetch Data
    //==================================================
    private var _fetchController: NSFetchedResultsController<NSFetchRequestResult>?
    
    internal override var fetchController: NSFetchedResultsController<NSFetchRequestResult>! {
        get {
            if _fetchController == nil {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ArticleEnglish.fetchRequest()
                
                let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                var arrayPredicate:[NSPredicate] = []
                if menuEnglish != nil {
                    arrayPredicate.append(NSPredicate(format: "menuEnglish = %@", menuEnglish!))
                    
                    if subMenuEnglish != nil {
                        arrayPredicate.append(NSPredicate(format: "subMenuEnglish = %@", subMenuEnglish!))
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
        SyncManager.syncEnglishArticles(subMenuEnglish: subMenuEnglish, view: view)
    }
    
    //==================================================
    // MARK: - func
    //==================================================
    
    
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
        navigationItem.title = menuEnglish?.title
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
            let destinationController = segue.destination as! DetailEnglishViewController
            destinationController.articleEnglish = sender as! ArticleEnglish
        }
        
        if (segue.identifier == "buyEnglish") {
            let destinationController = segue.destination as! BuyEnglishViewController
            destinationController.articleEnglish = sender as! ArticleEnglish
        }
        
        if (segue.identifier == "newMessage") {
            let destinationController = segue.destination as! ViewMessageViewController
            if let articleEnglishTemp =  sender as? ArticleEnglish  {
                destinationController.textMessage = "Сообщение к English статье: '\(String(describing: (articleEnglishTemp.title!) ))' \n"
            }
            
        }
    }
}


//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================
extension ListEnglishArticlesViewController {
    //MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListEnglishArticlesTableViewCell
        let articleEnglish = fetchController.object(at: indexPath) as! ArticleEnglish
        
        cell.articleEnglish = articleEnglish
        cell.mainView = view
        cell.topController = self
        
        cell.titleUI.text = articleEnglish.title
        cell.descriptUI.text = articleEnglish.shortDescr
        cell.nameMenuUI.text = articleEnglish.menuEnglish?.title
        if let date  = articleEnglish.dateCreated {
            cell.dateUI.text = DateManager.dateToString(date: date)
        } else {
            cell.dateUI.text = ""
        }
        
        
        if articleEnglish.isLike {
            cell.likeButtonUI.setImage(UIImage(named: "buttonLikeOn"), for: .normal)
        } else {
            cell.likeButtonUI.setImage(UIImage(named: "buttonLike"), for: .normal)
        }
        cell.likeButtonUI.setTitle(" " + String(articleEnglish.likes), for: .normal)
        
        if articleEnglish.price > 0 {
            cell.payButtonUI.setTitle(" " + String(articleEnglish.price), for: .normal)
        } else {
            cell.payButtonUI.setTitle(" free", for: .normal)
        }
        
        cell.photoUI.image = UIImage()
        cell.indicatorUI.startAnimating()
        DispatchQueue.main.async {
            ArticleEnglishManager.getImage(articleEnglish: articleEnglish, width: Int(cell.photoUI.layer.bounds.width), height: Int(cell.photoUI.layer.bounds.height)) { (image) in
                cell.photoUI.image = image
                cell.indicatorUI.stopAnimating()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleEnglish = fetchController.object(at: indexPath) as! ArticleEnglish
        
        if articleEnglish.isCanOpen {
            self.performSegue(withIdentifier: "fullText", sender: articleEnglish)
        } else {
            MessagerManager.showMessage(title: "", message: "Данная статья требует покупки!", theme: .error, view: self.view)
        }
        
    }
}


//==================================================
// MARK: - UISearchResultsUpdating
//==================================================
extension ListEnglishArticlesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if menuEnglish != nil {
            tempMenuEnglish = menuEnglish
        }
     }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        menuEnglish = tempMenuEnglish
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
        
        menuEnglish = nil
        
        searchBar.endEditing(true)
        fetchController = nil
        performFetch()
        reloadData()
        
        ArticleEnglishManager.getArticleEnglishSearchFromAPI(search: searchString) { (errorArticle) in
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
