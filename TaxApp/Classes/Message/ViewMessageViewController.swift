//
//  ViewMessageViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/30/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class ViewMessageViewController: BaseFetchTableViewController {
    
    
    @IBOutlet weak var mainButtonUI: UIButton!
    @IBOutlet weak var lineUI: UILabel!
    @IBOutlet weak var textUI: UITextView!
    @IBOutlet weak var deleteUI: UIBarButtonItem!
    
    var isActivKeyboard = false
    
    var messageMain: Message?
    var date = Date()
    var textMessage = ""
    //var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        configButton(button: mainButtonUI, isMakeCircle: true, isShadow: true)
        textUI.layer.cornerRadius = 5
        
        //deleteUI.isEnabled = false
        
        
        textUI.text = textMessage
//        if article != nil {
//            textUI.text = "Сообщение к статье: '\(String(describing: (article?.title!)! ))' \n"
//            //textUI.becomeFirstResponder()
//        }
        
        if let message = messageMain  {
            
            if message.isNew {
                message.isNew = false
                CoreDataManager.shared.saveContext()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Диалог"
        
        configTheme()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        scrollToLastRow()
    }
    
    
    //==================================================
    // MARK: - keyboard
    //==================================================
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let _ = self.view.window?.frame {
            
            isActivKeyboard = true
            
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height:  view.frame.height - keyboardSize.height)
            //scrollToLastRow()
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if !isActivKeyboard  {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            isActivKeyboard = false
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
    
    
    //==================================================
    // MARK: - Fetch Data
    //==================================================
    private var _fetchController: NSFetchedResultsController<NSFetchRequestResult>?
    
    internal override var fetchController: NSFetchedResultsController<NSFetchRequestResult>! {
        get {
            if _fetchController == nil {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Message.fetchRequest()
                
                let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                var arrayPredicate:[NSPredicate] = []
                if AppDataManager.shared.currentUser != nil {
                    arrayPredicate.append(NSPredicate(format: "user = %@", AppDataManager.shared.currentUser!))
                }
                
                if let message = messageMain {
                    arrayPredicate.append(NSPredicate(format: "mainID = %i", message.mainID))
                } else {
                    arrayPredicate.append(NSPredicate(format: "mainID = %i", -1))
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
    }
    
    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.mainColor()
        mainButtonUI.backgroundColor = ThemeManager.shared.mainColor()
        lineUI.backgroundColor = ThemeManager.shared.mainColor()
    }
    
    
    //==================================================
    // MARK: - action
    //==================================================
    @IBAction func sendMessage(_ sender: UIButton) {
        
        if  textUI.text == "" {
            //            let title = NSLocalizedString("Ошибка!", comment: "LoginViewController")
            //            let message = NSLocalizedString("Нужно написать текст!", comment: "LoginViewController")
            //
            //            MessagerManager.showMessage(title: title, message: message, theme: .error, view: self.tableView)
            return
        }
        
        loadingPlaceholderViewHidden = false
        var replyMessage: Message?
        let indexOfLastRowInLastSection = tableView.numberOfRows(inSection: 0)
        if indexOfLastRowInLastSection > 0 {
            let indexPath = IndexPath(row: indexOfLastRowInLastSection - 1, section: 0)
            replyMessage = fetchController.object(at: indexPath) as? Message
        }
        
        MessageManager.sendMessage(replyMessage: replyMessage, text: textUI.text) { (error, message) in
            if let error = error  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error)
                self.loadingPlaceholderViewHidden = true
                return
            }
            
            MessageManager.setMainID()
            self.textUI.text = ""
            
            if self.messageMain == nil && message != nil {
                self.messageMain = message
                self.fetchController = nil
                self.performFetch()
                self.reloadData()
            }
            
            self.loadingPlaceholderViewHidden = true
         }
    }
    
    
    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        
                let alert:UIAlertController=UIAlertController(title: NSLocalizedString("Удалить сообщение?", comment: "NewMessageViewController - UIAlertController"), message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                alert.view.tintColor = ThemeManager.shared.mainColor()
        
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)   { UIAlertAction in
        
                    if let message = self.messageMain {
                        message.kind = MessageKind.delete.rawValue
                        CoreDataManager.shared.saveContext()
                        self.navigationController!.popViewController(animated: true)
                    }
        
        
                }
                let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)   { UIAlertAction in
                    return
        
                }
        
                // Add the actions
                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
        
    }
    
}


//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================
extension ViewMessageViewController {
    
    func scrollToLastRow()  {
        let numberOfSections = tableView.numberOfSections
        let numberOfRows = tableView.numberOfRows(inSection: numberOfSections-1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    //MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchController.object(at: indexPath) as! Message
        
        if message.kind == MessageKind.inbox.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellAdmin", for: indexPath) as! ViewMessageTableViewCell
            cell.dateUI.text = DateManager.dateAndTimeToString(date: message.dateUpdate!)
            cell.photoUI.image = UIImage(named: "logo")
            cell.messageUI.text = message.text
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellUser", for: indexPath) as! ViewMessageTableViewCell
            cell.dateUI.text = DateManager.dateAndTimeToString(date: message.dateUpdate!)
            cell.photoUI.image = AppDataManager.shared.currentUser?.photoImage
            cell.messageUI.text = message.text
            return cell
        }
 
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                scrollToLastRow()
            }
        }
    }
    
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        scrollToLastRow()
      }
    
    
}

