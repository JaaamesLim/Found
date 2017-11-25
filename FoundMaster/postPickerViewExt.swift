//
//  postPickerViewExt.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 13/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

extension postVC {
    
    //function for selecting image
    func select(sender: UITapGestureRecognizer) {
        //set up alert view to select image
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //when library option is selected
        let library = { (action:UIAlertAction!) -> Void in
            
            //check if photo library is available on device
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        //when camera option is selected
        let camera = { (action:UIAlertAction!) -> Void in
            
            //check if camera is available on device
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        //delete image button
        let delete = { (action:UIAlertAction!) -> Void in
            self.img.image = UIImage(named: "ic_add_a_photo_white_48pt")
            self.img.contentMode = .center
        }
        
        alertController.addAction(UIAlertAction(title: "Camera", style:
            UIAlertActionStyle.default, handler: camera))
        alertController.addAction(UIAlertAction(title: "Library", style:
            UIAlertActionStyle.default, handler: library))
        alertController.addAction(UIAlertAction(title: "Cancel", style:
            UIAlertActionStyle.cancel, handler: nil))
        
        //check if image is prompt image
        if img.image != UIImage(named: "ic_add_a_photo_white_48pt") {
            alertController.addAction(UIAlertAction(title: "Delete Image", style:
                UIAlertActionStyle.default, handler: delete))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //converting to gray scale function
    func convertToGrayScale(image: UIImage) -> UIImage {
        let context = CIContext(options: nil)
        
        let currentFilter = CIFilter(name: "CIPhotoEffectMono")
        currentFilter!.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        
        return processedImage
    }
    
    //set image to image view once done selecting
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //set image view size according to image
        h = width/image.size.width * image.size.height
        
        scrollView.frame.size = CGSize(width: width, height: h + 350)
        
        tableView.contentInset.bottom = 0
        tableView.contentInset.bottom += h - 375
        
        img.contentMode = .scaleAspectFit
        img.image = convertToGrayScale(image: image)
        itemImg = convertToGrayScale(image: image)
        
        self.dismiss(animated: true, completion: nil)
    }
}
