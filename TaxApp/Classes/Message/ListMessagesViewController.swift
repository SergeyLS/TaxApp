//
//  ListMessagesViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/28/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class ListMessagesViewController: BaseFetchTableViewController {
    
    @IBOutlet weak var mainButtonUI: UIButton!
    
    var messageKind: MessageKind = MessageKind.inbox
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configButton(button: mainButtonUI, isMakeCircle: true, isShadow: true)
        
        if messageKind == MessageKind.delete {
            mainButtonUI.isHidden = true
        }
        
        if messageKind == MessageKind.inbox {
            NotificationManager.clearNotification(notificationKind: .inbox)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = messageKind.localized()
        configTheme()
     }
    
    
    
    //==================================================
    // MARK: - Fetch Data
    //==================================================
    private var _fetchController: NSFetchedResultsController<NSFetchRequestResult>?
    
    internal override var fetchController: NSFetchedResultsController<NSFetchRequestResult>! {
        get {
            if _fetchController == nil {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Message.fetchRequest()
                
                let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                var arrayPredicate:[NSPredicate] = []
                arrayPredicate.append(NSPredicate(format: "kind = %@", messageKind.rawValue))
                
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
    }
    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.mainColor()
        mainButtonUI.backgroundColor = ThemeManager.shared.mainColor()
    }
    
    //==================================================
    // MARK: - action
    //==================================================
    @IBAction func newMessageButton(_ sender: UIButton) {
        performSegue(withIdentifier: "message", sender: nil)
    }
    
    
    //==================================================
    // MARK: - Navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "message") {
            let destinationController = segue.destination as! ViewMessageViewController
            destinationController.messageMain = sender as? Message
        }

        
    }

}



//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================
extension ListMessagesViewController {
    //MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListMessagesTableViewCell
        let message = fetchController.object(at: indexPath) as! Message
        
        
        cell.dateUI.text = DateManager.dateAndTimeInTwoString(date: message.dateUpdate!)
        cell.textUI.text = message.text
        
        if message.isNew {
            cell.textUI.font = UIFont.boldSystemFont(ofSize: 13)
        } else {
            cell.textUI.font = UIFont.systemFont(ofSize: 13)
        }
        
        if message.replyID == 0 {
            cell.replyUI.isHidden = true
        } else {
            cell.replyUI.isHidden = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = fetchController.object(at: indexPath) as! Message
        
        //performSegue(withIdentifier: "write", sender: message)
        performSegue(withIdentifier: "message", sender: message)
    }
}
