//
//  BaseImageViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/12/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class BaseImageViewController: BaseViewController {
    
    @IBOutlet weak var photoUI: UIImageView!
    
    
    func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            selectImage(view: gesture.view!)
        }
    }
    
}



//==================================================
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//==================================================
extension BaseImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])    {
        picker.dismiss(animated: true, completion: nil)
        let tempImage=info[UIImagePickerControllerOriginalImage] as? UIImage
        //        let scaledImage = ImageManager.resizeImage(image: tempImage!, newWidth: 300)
        //        photoUI.image = scaledImage
        photoUI.image = tempImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)    {
        //print("picker cancel.")
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //==================================================
    // MARK: - Select image
    //==================================================
    func selectImage(view: UIView)    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        let alert:UIAlertController=UIAlertController(title: NSLocalizedString("Где взять фото?", comment: "Select photo"), message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.view.tintColor = ThemeManager.shared.mainColor()
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = view.bounds
        }

        let cameraAction = UIAlertAction(title: NSLocalizedString("Камера", comment: "From camera"), style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera(imagePicker)
        }
        let gallaryAction = UIAlertAction(title: NSLocalizedString("Галерея", comment: "From gallery"), style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary(imagePicker)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openCamera(_ imagePicker: UIImagePickerController)     {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertController(title: NSLocalizedString("No camera - no photo! :)", comment: "No camera - no photo"), message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alertWarning.view.tintColor = ThemeManager.shared.mainColor()
            alertWarning.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertWarning, animated: true, completion: nil)
            
        }
    }
    func openGallary(_ imagePicker: UIImagePickerController)    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}
