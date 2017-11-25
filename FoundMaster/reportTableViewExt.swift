//
//  reportTableViewExt.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 17/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//


extension reportVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catorgory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = catorgory[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        report(problem: catorgory[indexPath.row])
        performSegue(withIdentifier: "cancel", sender: self)
    }
}
