//
//  FileManagerTax.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/30/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation

class FileManagerTax {
    
    static func getFileURL(article: Article) -> URL? {
        guard  let link = article.linkText else {
            return nil
        }
        
        guard  let url = URL(string: link) else {
            return nil
        }
        
        
       let localFileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(article.id! + ".html")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: localFileURL.path) {
            //print("use local file: \(localFileURL.path)")
            return localFileURL
         }
        
        do {
            let data = try Data(contentsOf: url)
            do {
                _ = try!  data.write(to: localFileURL)
                return localFileURL
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        return url
    }
}
