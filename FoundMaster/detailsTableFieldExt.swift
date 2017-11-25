//
//  detailsTableViewExt.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 12/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

extension detailsVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if it is location row, open map
        if indexPath.row == 1 {
            performSegue(withIdentifier: "openMap", sender: self)
        }
    }
    
    //declare number of rows (fixed)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    //set up rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! detailsTVC
        
        switch indexPath.row {
            
        case 0:
            //first row  -  item name
            cell.label.text = name
            cell.icon.image = UIImage(named: "ic_label_48pt")
            
        case 1:
            //seocnd row  -  location
            cell.label.text = location
            cell.icon.image = UIImage(named: "ic_location_on_48pt")
            
        case 2:
            //third row  -  date
            cell.label.text = date
            cell.icon.image = UIImage(named: "ic_event_48pt")
            
        case 3:
            //forth row  -  name of person who found
            cell.label.text = person
            cell.icon.image = UIImage(named: "ic_account_circle_48pt")
            
        default:
            cell.label.text = ""
            cell.icon.image = nil
            
        }
        
        return cell
    }
}
