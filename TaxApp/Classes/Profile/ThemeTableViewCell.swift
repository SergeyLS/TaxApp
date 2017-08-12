//
//  ThemeTableViewCell.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/13/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImageUI: UIImageView!
    @IBOutlet weak var nameUI: UILabel!
    @IBOutlet weak var hoursUI: UILabel!
    @IBOutlet weak var minutesUI: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func reloadData()  {
        hoursUI.backgroundColor = UIColor.white
        hoursUI.layer.borderWidth = 2
        hoursUI.layer.borderColor = ColorManager.colorGrayBorder.cgColor
        
        minutesUI.backgroundColor = UIColor.white
        minutesUI.layer.borderWidth = 2
        minutesUI.layer.borderColor = ColorManager.colorGrayBorder.cgColor
     }

}
