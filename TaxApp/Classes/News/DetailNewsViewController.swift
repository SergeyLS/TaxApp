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
    
    var article: Article!
    
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoUI.image = article.photoImage
        titleUI.text = article.title
        dateUI.text = DateManager.dateAndTimeToString(date: article.dateCreated!)
        
        if let link = article.linkText {
            webView.delegate = self
            if let url = URL(string: link) {
                let request = URLRequest(url: url)
                webView.loadRequest(request)
            }
            
        }
        
        scrollViewUI.layer.cornerRadius = 5
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        stopObservingHeight()
    }
    
    
    //==================================================
    // MARK: - observ
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


