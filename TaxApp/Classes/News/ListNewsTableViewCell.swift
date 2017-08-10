//
//  ListNewsTableViewCell.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class ListNewsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleUI: UILabel!
    @IBOutlet weak var descriptUI: UILabel!
    @IBOutlet weak var bottomViewUI: UIView!
    @IBOutlet weak var mainViewUI: UIView!
    @IBOutlet weak var photoUI: UIImageView!
    @IBOutlet weak var nameMenuUI: UILabel!
    @IBOutlet weak var dateUI: UILabel!
    @IBOutlet weak var indicatorUI: UIActivityIndicatorView!
    @IBOutlet weak var likeButtonUI: UIButton!
    
    var article: Article!
    var mainView: UIView!

    
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
        mainViewUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        mainViewUI.layer.shadowRadius = 3.0
        mainViewUI.layer.shadowOpacity = 0.4
        mainViewUI.layer.masksToBounds = false
        
    }
    
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        
        if article.isLike {
            return
        }
        
        ArticleManager.getArticleLike(article: article) { (errorArticle) in
            if let error = errorArticle  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.mainView)
                return
            }
  
            
            self.article.isLike = true
            CoreDataManager.shared.saveContext()
        }
     }
    

}
