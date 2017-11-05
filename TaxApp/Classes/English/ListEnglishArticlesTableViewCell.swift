//
//  ListNewsTableViewCell.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ListEnglishArticlesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleUI: UILabel!
    @IBOutlet weak var descriptUI: UILabel!
    @IBOutlet weak var bottomViewUI: UIView!
    @IBOutlet weak var mainViewUI: UIView!
    @IBOutlet weak var photoUI: UIImageView!
    @IBOutlet weak var nameMenuUI: UILabel!
    @IBOutlet weak var dateUI: UILabel!
    @IBOutlet weak var indicatorUI: UIActivityIndicatorView!
  
    @IBOutlet weak var likeButtonUI: UIButton!
    @IBOutlet weak var mailButtonUI: UIButton!
    @IBOutlet weak var payButtonUI: UIButton!
    
    
    var articleEnglish: ArticleEnglish!
    var mainView: UIView!
    var topController: ListEnglishArticlesViewController?

    
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
        
        likeButtonUI.setTitle(nil, for: .normal)
        //likeButtonUI.setImage(nil, for: .normal)
        
        mailButtonUI.setTitle(nil, for: .normal)
        //mailButtonUI.setImage(nil, for: .normal)
        
        payButtonUI.setTitle(nil, for: .normal)
        //payButtonUI.setImage(nil, for: .normal)
      }

    
    func addShadow()  {
        mainViewUI.layer.shadowColor = UIColor.darkGray.cgColor
        mainViewUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        mainViewUI.layer.shadowRadius = 3.0
        mainViewUI.layer.shadowOpacity = 0.4
        mainViewUI.layer.masksToBounds = false
        
    }
    
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        if articleEnglish.isLike {
            ArticleEnglishManager.getArticleEnglishUnLike(articleEnglish: articleEnglish) { (errorArticle) in
                
                if let error = errorArticle  {
                    MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error)
                    return
                }
            }
        } else {
            ArticleEnglishManager.getArticleEnglishLike(articleEnglish: articleEnglish) { (errorArticle) in
                
                if let error = errorArticle  {
                    MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error)
                    return
                }
            }
        }

     }
    
    
    @IBAction func payButtonAction(_ sender: UIButton) {
        if articleEnglish.isCanOpen {
            topController?.performSegue(withIdentifier: "fullText", sender: articleEnglish)
            return
        }

        if AppDataManager.shared.userLogin == User.noLoginUserKey {
            UserManager.messageNoLogin(view: mainView)
            return
        }
        
        topController?.performSegue(withIdentifier: "buyEnglish", sender: articleEnglish)
      }
    
    
    @IBAction func messageAction(_ sender: UIButton) {
        if AppDataManager.shared.userLogin == User.noLoginUserKey {
            UserManager.messageNoLogin(view: mainView)
            return
        }

        topController?.performSegue(withIdentifier: "newMessage", sender: articleEnglish)
    }
    

}
