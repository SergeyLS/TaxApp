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
    @IBOutlet weak var bottomViewUI: UIView!
    @IBOutlet weak var mainViewUI: UIView!
    @IBOutlet weak var photoUI: UIImageView!
    @IBOutlet weak var nameMenuUI: UILabel!
    @IBOutlet weak var dateUI: UILabel!
    @IBOutlet weak var indicatorUI: UIActivityIndicatorView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func prepareForReuse() {
        titleUI.text = nil
        descriptUI.text = nil
        photoUI.image = nil
        nameMenuUI.text = nil
        dateUI.text = nil
      }

    
    func addShadow()  {
        mainViewUI.layer.shadowColor = UIColor.darkGray.cgColor
        mainViewUI.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mainViewUI.layer.shadowRadius = 1.0
        mainViewUI.layer.shadowOpacity = 0.18
        mainViewUI.layer.masksToBounds = false
        
    }

}
