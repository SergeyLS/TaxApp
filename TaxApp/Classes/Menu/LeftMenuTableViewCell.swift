//
//  LeftMenuTableViewCell.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/3/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameUI: UILabel!
    @IBOutlet weak var nextImageUI: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
