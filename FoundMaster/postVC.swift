//
//  postVC.swift
//  Found
//
//  Created by Storm Lim on 6/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class postVC: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var ref: FIRDatabaseReference!
    
    let storage = FIRStorage.storage()
    
    var height = CGFloat()
    var width = CGFloat()
    var cWidth = CGFloat()
    var small = CGFloat()
    
    @IBOutlet weak var loading: UIView!
    @IBOutlet weak var loadBox: UIView!
    
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var colourView: UIView!
    @IBOutlet weak var darken: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var poster: UILabel!
    
    var imagePick = UIImagePickerController()
    var currentPlacemark:CLPlacemark?
    
    var check = 0
    var h: CGFloat = 375
    var itemImg = UIImage()
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var datePic: UIDatePicker!
    @IBOutlet weak var colourBtn: UIButton!
    @IBOutlet weak var colourPic: UICollectionView!
    var colour = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = view.frame.width
        height = view.frame.height
        cWidth = width - 75 - 75
        
        loadBox.layer.cornerRadius = 20
        
        colourPic.delegate = self
        colourPic.dataSource = self
        
        colourBtn.layer.cornerRadius = 15
        colourBtn.layer.borderWidth = 2
        colourBtn.layer.borderColor = UIColor.black.cgColor
        
        mapView.delegate = self
        
        let defaults = UserDefaults.standard
        
        poster.text = "Found by " + defaults.string(forKey: "name")!
        
        nameTF.delegate = self
        locationTF.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(postVC.select(sender:)))
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(postVC.keyboard(notification:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    //when colour picker is clicked
    @IBAction func pickColour(_ sender: Any) {
        //animate colour picker opening
        nameTF.resignFirstResponder()
        locationTF.resignFirstResponder()
        darken.isHidden = false
        colourPic.frame.origin.y = height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: [], animations: {
            self.colourPic.center.y = (self.height)/2
            self.darken.alpha = 1
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            locationTF.becomeFirstResponder()
        }
        
        if textField == locationTF {
            locationTF.resignFirstResponder()
            place()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == locationTF {
            place()
        }
    }
    
    func place() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationTF.text!, completionHandler: { placemarks, error in
            if error != nil {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.locationTF.text!
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
        }
        view.pinTintColor = UIColor.black
        return view
    }
        
    func keyboard(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        print(frame)
        tableView.contentInset.bottom = 0
        tableView.contentInset.bottom += h - 375 + frame
    }

}
