//
//  ViewMessageTableViewCell.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/31/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ViewMessageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var photoUI: UIImageView!
    @IBOutlet weak var messageUI: UILabel!
    @IBOutlet weak var dateUI: UILabel!
    @IBOutlet weak var viewTextUI: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoUI.layer.cornerRadius = photoUI.layer.bounds.height/2
        viewTextUI.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
