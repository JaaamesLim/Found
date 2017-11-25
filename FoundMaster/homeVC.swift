//
//  homeVC.swift
//  Found
//
//  Created by Storm Lim on 6/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import UIKit
import Firebase

class homeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    var items = [item]()
    var images = [UIImage]()
    
    var searched = [item]()
    var searchedImg = [UIImage]()
    
    var width = CGFloat()
    var height = CGFloat()
    
    var small = CGFloat()
    
    var searching = false
    
    //connecting UIVIews
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loading: UILabel!
    
    var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.frame.width
        height = view.frame.height
        fetch()
        
        titleLbl.layer.cornerRadius = 17
        titleLbl.clipsToBounds = true
        
        searchBar.delegate = self
        searchBar.alpha = 0
        searchBar.clipsToBounds = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.top = -20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //check if user is logged in, if not send it to log in view controller
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "loggedIn") {
            performSegue(withIdentifier: "logIn", sender: self)
        }
    }
    
    //when searched button is clicked
    @IBAction func search(_ sender: Any) {
        if searching {
            searchBar.resignFirstResponder()
            UIView.animate(withDuration: 0.5, animations: {
                self.searchBar.alpha = 0
                self.searchBar.frame.origin.y = -44
                self.titleLbl.alpha = 1
                self.titleLbl.frame.origin.y = 5
            }, completion: { (value: Bool) in
                self.searching = false
                self.collectionView.reloadData()
            })
        } else {
            searchBar.becomeFirstResponder()
            UIView.animate(withDuration: 0.5, animations: {
                self.searchBar.alpha = 1
                self.searchBar.frame.origin.y = 0
                self.titleLbl.alpha = 0
                self.titleLbl.frame.origin.y = 44
            }, completion: { (value: Bool) in
                self.searching = true
                self.collectionView.reloadData()
            })
        }
    }
    
    //fetch data from the database
    func fetch() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let object = item()
                
                object.setValuesForKeys(dict)
                
                if let imgUrl = URL(string: object.imgUrl!) {
                    let task = URLSession.shared.dataTask(with: imgUrl) { data, response, error in
                        //check for errors
                        if error != nil {
                            
                        }
                        
                        let image = UIImage(data: data!)
                        self.images.append(image!)
                        self.items.append(object)
                        
                        self.collectionView.reloadData()
                        UIView.animate(withDuration: 0.5, animations: {
                            self.loading.frame.origin.y = 64 - 25
                        }, completion: { (value: Bool) in
                            self.loading.isHidden = true
                        })
                    }
                    task.resume()
                }
            }
            }, withCancel: nil)
        
    }
    
    //send information to detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            if let indexPath = self.collectionView?.indexPath(for: sender as! homeCVC) {
                let dVC = segue.destination as! detailsVC
                
                var img = images[indexPath.row]
                
                if searching {
                    img = searchedImg[indexPath.row]
                }
                
                dVC.img = img
                
                var object = items[indexPath.row]
                
                if searching {
                    object = searched[indexPath.row]
                }
                
                dVC.name = object.name!
                dVC.location = object.location!
                dVC.date = object.date!
                dVC.person = object.founder!
                dVC.email = object.email!
                dVC.colour = object.colour!
                dVC.id = object.UUID!
            }
        }
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) {
        
    }

}
