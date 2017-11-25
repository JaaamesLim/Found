//
//  GoogleSignInVC.swift
//  FoundMaster
//
//  Created by Storm Lim on 7/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import UIKit
import Firebase

class GoogleSignInVC: UIViewController, GIDSignInUIDelegate {

    var height = CGFloat()
    var width = CGFloat()
    var imgWidth = CGFloat()
    
    @IBOutlet weak var logInBtn: GIDSignInButton!
    
    var bg = UIImageView()
    var img = UIImage(named: "sst")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegate
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //set variables 
        height = view.frame.height
        width = view.frame.width
        imgWidth = height/(img?.size.height)! * (img?.size.width)!
        
        bg.frame = CGRect(x: (width - imgWidth)/2, y: 0, width: imgWidth, height: height)
        bg.image = convertToGrayScale(image: img!)
        
        view.insertSubview(bg, belowSubview: logInBtn)
    }
    
    func convertToGrayScale(image: UIImage) -> UIImage {
        let context = CIContext(options: nil)
        
        let currentFilter = CIFilter(name: "CIPhotoEffectMono")
        currentFilter!.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        
        return processedImage
    }
    
}
