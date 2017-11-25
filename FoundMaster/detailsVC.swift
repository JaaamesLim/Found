//
//  detailsVC.swift
//  Found
//
//  Created by Storm Lim on 6/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation

class detailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate {
    
    var width = CGFloat()
    var height = CGFloat()
    var cWidth = CGFloat()
    var small = CGFloat()
    
    var img = UIImage()
    var name = String()
    var location = String()
    var date = String()
    var person = String()
    var email = String()
    var colour = String()
    var id = String()
    
    var colourChk = String()
    
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var darken: UIView!
    @IBOutlet weak var colourPic: UICollectionView!

    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var itemImg: UIImageView!
    var imgHeight = CGFloat()
    
    @IBOutlet weak var tableView: UITableView!
    
    var colours = [
        UIColor(r: 255, g: 0, b: 0),
        UIColor(r: 255, g: 128, b: 0),
        UIColor(r: 255, g: 255, b: 0),
        UIColor(r: 255, g: 0, b: 255),
        UIColor(r: 0, g: 128, b: 255),
        UIColor(r: 0, g: 255, b: 0),
        UIColor(r: 128, g: 64, b: 0),
        UIColor(r: 255, g: 255, b: 255),
        UIColor(r: 0, g: 0, b: 0)]
    
    var coloursStr = ["red", "orange", "yellow", "pink", "blue", "green", "brown", "white", "black"]
    var tries = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.frame.width
        height = view.frame.height
        cWidth = width - 75 - 75
        
        //configure item imageView
        imgHeight = width/img.size.width * img.size.height
        itemImg.alpha = 0
        itemImg.frame = CGRect(x: 0, y: 64, width: width, height: imgHeight)
        //item image view fade in
        UIView.animate(withDuration: 1, animations: {
            self.itemImg.alpha = 1
        })
        
        //make space for the item image
        tableView.contentInset.top = imgHeight
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        colourPic.delegate = self
        colourPic.dataSource = self
        
        //find cell size
        for i in 58 ... 60 {
            if (cWidth - CGFloat(i)).truncatingRemainder(dividingBy: 3) == 0 {
                //return the amount that was needed to minus off
                colourPic.contentInset = UIEdgeInsets(top: CGFloat(i)/3, left: 0, bottom: 0, right: 0)
            }
        }
        
        if email == UserDefaults.standard.string(forKey: "email") {
            emailBtn.setImage(UIImage(named: "ic_photo_camera_48pt"), for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //ensure that item imageView is really configured
        itemImg.frame = CGRect(x: 0, y: 64, width: width, height: imgHeight)
        itemImg.image = img
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y + imgHeight
        if y <= 0 {
            let newHeight = imgHeight - y //add content inset top to original height, since y always negative: imgHeight - y
            let newWidth = newHeight/imgHeight * width //find new width of image using ratio
            let x = (width - newWidth)/2 //find x value from difference in width
            itemImg.frame = CGRect(x: x, y: 64, width: newWidth, height: newHeight)
        } else {
            //half the scrolling
            itemImg.frame = CGRect(x: 0, y: 64 - y/2, width: width, height: imgHeight)
        }
    }
    
    //close colour picker
    @IBAction func close(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.darken.alpha = 0
            self.colourPic.frame.origin.y = self.height
            
        }, completion: { (value: Bool) in
            self.darken.isHidden = true
        })
    }
    
    //send location to map
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openMap" {
            let dVC = segue.destination as! MapVC
            dVC.location = location
        } else if segue.identifier == "report" {
            let dVC = segue.destination as! reportVC
            dVC.id = id
        } else  if segue.identifier == "takePic" {
            let dVC = segue.destination as! pictureVC
            dVC.UUID = id
        }
        
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) {
        
    }
    
}
