//
//  textFieldExt.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 11/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

extension homeVC {
    //when active, start searching
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searching = true
        collectionView.reloadData()
    }
    
    //when ended
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        search()
    }
    
    //when search button is clicked.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        search()
        return true
    }
    
    func search() {
        //clear all first
        searched.removeAll()
        searchedImg.removeAll()
        
        //check through array to see what matches to search bar
        for i in 0 ..< items.count {
            if (items[i].name?.contains(searchBar.text!))! {
                searched.append(items[i])
                searchedImg.append(images[i])
            }
        }
        
        //check if searched array is empty and searchbar is empty and it's not searching then.
        searching = !(searched.isEmpty && searchBar.text == "")
        
        //reload data
        collectionView.reloadData()
    }
}
