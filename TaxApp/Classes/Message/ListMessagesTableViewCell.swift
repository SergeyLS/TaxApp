//
//  ListMessagesTableViewCell.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/28/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ListMessagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateUI: UILabel!
    @IBOutlet weak var textUI: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func prepareForReuse() {
        dateUI.text = nil
        textUI.text = nil
    }

}
