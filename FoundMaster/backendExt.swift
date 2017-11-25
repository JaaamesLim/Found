//
//  backendExt.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 13/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import Firebase

extension postVC {
    
    //post button is clicked
    @IBAction func upload(_ sender: Any) {
        checkValues()
    }
    
    //check posting criteria before posting
    func checkValues() {
        //reset check
        check = 0
        
        //check if image is not prompt image
        if img.image == UIImage(named: "ic_add_a_photo_white_48pt") {
            img.backgroundColor = UIColor.red
            UIView.animate(withDuration: 0.5, animations: {
                self.img.backgroundColor = UIColor.black
            })
        } else {
            check += 1
        }
        
        //check name textField is not empty
        if nameTF.text == "" {
            nameView.backgroundColor = UIColor.red
            UIView.animate(withDuration: 0.5, animations: {
                self.nameView.backgroundColor = UIColor.white
            })
        } else {
            check += 1
        }
        
        //check location textField is not empty
        if locationTF.text == "" {
            locationView.backgroundColor = UIColor.red
            UIView.animate(withDuration: 0.5, animations: {
                self.locationView.backgroundColor = UIColor.white
            })
        } else {
            check += 1
        }
        
        //if all satisfies criteria, continue to upload image
        if check == 3 {
            loading.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.loading.alpha = 1
            })
            upload()
            nameTF.resignFirstResponder()
            locationTF.resignFirstResponder()
        }
    }
    
    //add image to backend
    func upload() {
        //compress image and convert to JPEG
        let uploadData = UIImageJPEGRepresentation(itemImg, 0.01/100)
        
        //give image unique id
        let imgName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("Item Images").child("\(imgName).jpg")
        storageRef.put(uploadData!, metadata: nil, completion: { (metadata, error) in
            //checking for error
            if error != nil {
                print(error)
                return
            }
            //if everything goes well continue to post
            self.addToChild(metadata: metadata!)
        })
    }
    
    func addToChild(metadata: FIRStorageMetadata) {
        //set temporary variables for posting
        let name = "\(nameTF.text!)"
        let founder = "\(UserDefaults.standard.value(forKey: "name")!)"
        let email = "\(UserDefaults.standard.value(forKey: "email")!)"
        let location = "\(locationTF.text!)"
        
        //set date into specified format
        let df = DateFormatter()
        df.dateFormat = "MMM / dd / yyyy"
        let date = df.string(from: datePic.date)
        
        let colour = self.colour
        
        //set unique string for post
        let uuid = UUID().uuidString
        
        //post
        if let imgUrl = metadata.downloadURL()?.absoluteString {
            ref = FIRDatabase.database().reference()
            let key = ref.child("item").childByAutoId().key
            let set = [
                "name" : name,
                "founder" : founder,
                "email" : email,
                "location" : location,
                "date" : date,
                "colour" : colour,
                "imgUrl" : imgUrl,
                "UUID": uuid]
            let childUpdates = ["/posts/\(key)": set]
            ref.updateChildValues(childUpdates)
        }
        //once done, return home
        let alert = UIAlertController(title: nil, message: "Please take a picture of the person who claims this item", preferredStyle: .alert)
        
        let close = UIAlertAction(title: "Okay", style: .cancel, handler: { UIAlertAction in
            self.performSegue(withIdentifier: "unwind", sender: self)
        })
        
        alert.addAction(close)
        self.present(alert, animated: true, completion: nil)
    }
}
