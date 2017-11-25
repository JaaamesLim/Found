//
//  detailsMailViewExt.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 12/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import MessageUI

extension detailsVC {
    @IBAction func mail(_ sender: Any) {
        if email == UserDefaults.standard.string(forKey: "email") {
            performSegue(withIdentifier: "takePic", sender: self)
        } else {
            //ensure not brute force
            if UserDefaults.standard.object(forKey: id) == nil && tries < 2 {
                darken.isHidden = false
                colourPic.frame.origin.y = height
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: [], animations: {
                    self.colourPic.center.y = (self.height)/2
                    self.darken.alpha = 1
                }, completion: nil)
            } else {
                UserDefaults.standard.set("brute force", forKey: self.id)
                let alert = UIAlertController(title: nil, message: "Stop trying, I already gave you a second chance.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //intialize email
    func showEmail() {
        
        //check if the device is capable to send email
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        //set the test for email
        let emailTitle = "Claiming Item (\(name))"
        let messageBody = "Hey,\nI think this item is mine."
        let toRecipients = [email]
        
        //initialize the mail composer and populate the mail content
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
        
        //add image of item to email
        mailComposer.addAttachmentData(UIImageJPEGRepresentation(img, 1)!, mimeType: "image/jpg", fileName: "item.jpg")
        
        present(mailComposer, animated: true, completion: nil)
    }
    
    //check if email has been sent
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Failed to send: \(error)")
        default: break
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
