
//
//  signInExt.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 11/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import UIKit
import Firebase

extension GoogleSignInVC {
    
    //when user hassigned in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        //checking for error
        if let error = error {
            print(error)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            
        }
    }
    
    //code when finished logging in
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
        //close view
        self.dismiss(animated: true, completion: {
            
            //remember that user has logged in
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "loggedIn")
            
            //go back to home screen
            self.performSegue(withIdentifier: "loggedIn", sender: self)
            
        })
        
    }
    
}
