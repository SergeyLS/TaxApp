//
//  DetailNewsViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/15/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

var MyObservationContext = 0

class DetailNewsViewController: BaseViewController {
    
    @IBOutlet weak var scrollViewUI: UIScrollView!
    @IBOutlet weak var photoUI: UIImageView!
    @IBOutlet weak var dateUI: UILabel!
    @IBOutlet weak var titleUI: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var likeButtonUI: UIButton!
    @IBOutlet weak var spinerImage: UIActivityIndicatorView!
    
    
    var article: Article!
    
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.async {
            ArticleManager.getImage(article: self.article,
                                    width: Int(self.photoUI.layer.bounds.width),
                                    height: Int(self.photoUI.layer.bounds.height)) { (image) in
                                        self.photoUI.image = self.article.photoImage
                                        self.spinerImage.stopAnimating()
            }
        }
        
        titleUI.text = article.title
        dateUI.text = DateManager.dateAndTimeToString(date: article.dateCreated!)
        
        
        webView.delegate = self
        
        if let url = FileManagerTax.getFileURL(article: article) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
        
        chengeLike()
        
        scrollViewUI.layer.cornerRadius = 5
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let menu = article.menu {
            navigationItem.title = menu.title
        }
        configTheme()
    }
    
    
    deinit {
        stopObservingHeight()
    }
    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.mainColor()
    }
    
    func chengeLike()  {
        if article.isLike {
            likeButtonUI.setImage(UIImage(named: "buttonLikeOn"), for: .normal)
        } else {
            likeButtonUI.setImage(UIImage(named: "buttonLike"), for: .normal)
        }
        
        likeButtonUI.setTitle(String(article.likes), for: .normal)
    }
    
    //==================================================
    // MARK: - action
    //==================================================
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        
        if article.isLike {
            return
        }
        
        ArticleManager.getArticleLike(article: article) { (errorArticle) in
            if let error = errorArticle  {
                MessagerManager.showMessage(title: "Ошибка!", message: error, theme: .error, view: self.view)
                return
            }
            
            self.chengeLike()
        }
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        if AppDataManager.shared.userLogin == User.noLoginUserKey {
            UserManager.messageNoLogin(view: view)
            return
        }

        performSegue(withIdentifier: "newMessage", sender: article)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        let defaultText = article.title ?? ""
        
        var activityItems = [Any]()
        activityItems.append(defaultText)
        if let image = article.photoImage {
            activityItems.append(image)
        }
        if let url = URL(string: article.linkText!) {
            activityItems.append(url)
        }
        
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)

    }
    
    @IBAction func saveToDiskAction(_ sender: UIButton) {
        MessagerManager.showMessage(title: "", message: "Статья сохранена, можно читать offline!", theme: .success, view: self.view)
    }
    
    
    //==================================================
    // MARK: - Navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newMessage") {
            let destinationController = segue.destination as! ViewMessageViewController
            destinationController.article = sender as? Article
        }
    }
    
    
    //==================================================
    // MARK: - observing
    //==================================================
    
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.new])
        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true;
    }
    
    func stopObservingHeight() {
        if observing {
            webView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
            observing = false
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,
            let context = context else {
                super.observeValue(forKeyPath: nil, of: object, change: change, context: nil)
                return
        }
        switch (keyPath, context) {
        case("contentSize", &MyObservationContext):
            webViewHeightConstraint.constant = webView.scrollView.contentSize.height
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}


//==================================================
// MARK: - extension - UIWebViewDelegate
//==================================================
extension DetailNewsViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //print(webView.request?.url ?? "nil")
        webViewHeightConstraint.constant = webView.scrollView.contentSize.height
        if (!observing) {
            startObservingHeight()
        }
        spinner.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        spinner.stopAnimating()
    }
    
}


