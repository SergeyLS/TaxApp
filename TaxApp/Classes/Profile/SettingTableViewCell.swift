//
//  SettingTableViewCell.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/12/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftImageUI: UIImageView!
    @IBOutlet weak var nameUI: UILabel!
    @IBOutlet weak var countUI: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func reloadData()  {
        countUI.backgroundColor = UIColor.white
        countUI.setTitleColor(ThemeManager.shared.mainColor(), for: .normal)
        countUI.layer.borderWidth = 1
        countUI.layer.borderColor = ThemeManager.shared.mainColor().cgColor
        countUI.layer.cornerRadius = countUI.frame.size.height / 2
    }

}
