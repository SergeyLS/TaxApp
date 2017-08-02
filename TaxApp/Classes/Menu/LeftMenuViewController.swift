//
//  LeftMenuViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/2/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class LeftMenuViewController: BaseViewController {
    
    @IBOutlet weak var photoUI: UIImageView!
    @IBOutlet weak var nameUI: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        photoUI.layer.cornerRadius = photoUI.bounds.size.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
