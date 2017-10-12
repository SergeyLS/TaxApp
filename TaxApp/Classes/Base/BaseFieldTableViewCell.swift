//
//  BaseFieldTableViewCell.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/16/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class BaseFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var nameUI: UILabel!
    @IBOutlet weak var fieldUI: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func prepareForReuse() {
        nameUI.text = nil
        if fieldUI != nil {
            fieldUI.text = nil
        }
    }

}
