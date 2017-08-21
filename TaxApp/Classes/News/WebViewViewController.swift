//
//  WebViewViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class WebViewViewController: BaseViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var article: Article!
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        let articleIdString = article?.id!
        let urlString = ConfigAPI.getArticlePayString
        
        guard var urlComponents = URLComponents(string: urlString) else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: AppDataManager.shared.userToken),
            URLQueryItem(name: "article", value: articleIdString!),
            URLQueryItem(name: "type", value: "article")
        ]
        
        //print(urlComponents.url)
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            webView.loadRequest(request)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = NSLocalizedString("Оплата", comment: "WebViewViewController - navigationItem.title")
    }
    
    
}



//==================================================
// MARK: - extension - UIWebViewDelegate
//==================================================
extension WebViewViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        spinner.stopAnimating()
    }
    
}


