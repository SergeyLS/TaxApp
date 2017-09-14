//
//  ListEnglishCollectionViewCell.swift
//  TaxApp
//
//  Created by Sergey Leskov on 9/14/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ListEnglishCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var viewPhotoUI: UIView!
    @IBOutlet weak var photoUI: UIImageView!
    @IBOutlet weak var nameUI: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewPhotoUI.layer.cornerRadius = 20
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameUI.text = nil
        photoUI.image = nil
     }

}
