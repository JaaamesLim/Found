//
//  reportVC.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 17/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import UIKit
import Firebase

class reportVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var id = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    var catorgory = [
        "Cartoon or Fantasy Violence",
        "Realistic Violence",
        "Prolonged Graphic or Sadistic Realistic Violence",
        "Profanity or Crude Humor",
        "Mature/Suggestive Themes",
        "Alcohol, Tobacco, or Drug Use or References",
        "Sexual Content or Nudity"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    func report(problem: String) {
        let ref = FIRDatabase.database().reference()
        let key = ref.child("reports").childByAutoId().key
        let set = [
            "UUID" : id,
            "Problem" : problem]
        let childUpdates = ["/reports/\(key)": set]
        ref.updateChildValues(childUpdates)
    }
}
