//
//  pictureBackendExt.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 30/1/17.
//  Copyright © 2017 J.Lim. All rights reserved.
//

import UIKit
import Firebase

extension pictureVC {
    //add image to backend
    func upload() {
        //compress image and convert to JPEG
        let uploadData = UIImageJPEGRepresentation(stillImage!, 0.01/100)
        
        //give image unique id
        let imgName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("Collector Images").child("\(imgName).jpg")
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
        let id = UUID
        let location = "\(locValue)"
        
        //set date into specified format
        let date = "\(Date())"
        
        let ref: FIRDatabaseReference!
        
        //post
        if let imgUrl = metadata.downloadURL()?.absoluteString {
            ref = FIRDatabase.database().reference()
            let key = ref.child("item").childByAutoId().key
            let set = [
                "id" : id,
                "location" : location,
                "date" : date,
                "imgUrl" : imgUrl]
            let childUpdates = ["/claims/\(key)": set]
            ref.updateChildValues(childUpdates)
        }
        
        endLoad()
        self.performSegue(withIdentifier: "unwind", sender: self)
    }
}
