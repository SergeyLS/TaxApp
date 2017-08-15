//
//  DetailNewsViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/15/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class DetailNewsViewController: BaseViewController {
    
    @IBOutlet weak var mainViewUI: UIView!
    @IBOutlet weak var photoUI: UIImageView!
    @IBOutlet weak var dateUI: UILabel!
    @IBOutlet weak var titleUI: UILabel!
    @IBOutlet weak var textUI: UITextView!

    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoUI.image = article.photoImage
        titleUI.text = article.shortDescr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
