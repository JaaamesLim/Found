//
//  MapVC.swift
//  FoundMaster
//
//  Created by Storm Lim on 8/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {

    var location = ""
    var currentPlacemark:CLPlacemark?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        
        place()
    }
    
    //declare place
    func place() {
        let geoCoder = CLGeocoder()
        
        //add location using string
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            //check for errors
            if error != nil {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                //get the first placemark
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                
                //add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.location
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    //display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
    }
    
    //add annotation to map
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

}
