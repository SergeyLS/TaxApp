//
//  ListNewsTableViewCell.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ListNewsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleUI: UILabel!
    @IBOutlet weak var descriptUI: UILabel!
    
    @IBOutlet weak var mainViewUI: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainViewUI.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func prepareForReuse() {
        titleUI.text = nil
        descriptUI.text = nil
      }

}
