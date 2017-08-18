//
//  ImageManager.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/18/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
class ImageManager {
    
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        var height = image.size.height
        var width = image.size.width
        
        if width > height  {
            let scale = newWidth / image.size.width
            height = image.size.height * scale
            width = newWidth
        } else {
            let scale = newWidth / image.size.height
            width = image.size.width * scale
            height = newWidth
        }
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        
        
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    static func imageToDataAndResize(image: UIImage?, newWidth: CGFloat) -> Data {
        var returnImage = UIImage()
        if let tempImage = image {
            returnImage = tempImage
        }
        returnImage = resizeImage(image: returnImage, newWidth: newWidth)
        
        return UIImagePNGRepresentation(returnImage)!
    }
    
    
    static func temporaryPhotoURL(name: String, photoImage: UIImage) -> URL  {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(name).appendingPathExtension("jpg")
        
        
        let photoData = ImageManager.imageToDataAndResize(image: photoImage, newWidth: 300)
        
        try? photoData.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }

    
//    static func getDefaultImageAsData() -> Data {
//        let tempPhoto = UIImage(named: "noPhoto")
//        let photoData = UIImagePNGRepresentation(tempPhoto!)
//        return photoData!
//    }
}

