//
//  postCollectionViewExt.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 12/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

extension postVC {
    //declare size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //find out how much the width must be minused off before it is divisible by 3
        for i in 58 ... 60 { //instead of 1...3 58...60 (mulitple of three)
            //set cell size
            small = (cWidth - CGFloat(i))/3
            //check
            if (cWidth - CGFloat(i)).truncatingRemainder(dividingBy: 3) == 0 {
                return CGSize(width: small, height: small)
            }
        }
        
        return CGSize(width: width, height: width)
    }
    
    //declare spacing in between cells (left and right)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //find cell size
        for i in 58 ... 60 {
            if (cWidth - CGFloat(i)).truncatingRemainder(dividingBy: 3) == 0 {
                //return the amount that was needed to minus off
                return CGFloat(i)/3
            }
        }
        return 0
    }
    
    //delcare spacing between cells (up and down)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //find cell size
        for i in 58 ... 60 {
            if (cWidth - CGFloat(i)).truncatingRemainder(dividingBy: 3) == 0 {
                //return the amount that was needed to minus off
                return CGFloat(i)/3
            }
        }
        return 0
    }
    
    //declare number of cells  -  9 cells for 9 colours
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    //set up cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = self.colours[indexPath.row]
        
        //make cell into circle
        cell.layer.cornerRadius = small/2
        cell.clipsToBounds = true
        
        return cell
    }
    
    //what happens when cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //set colour selected
        self.colour = self.coloursStr[indexPath.row]
        //animate closing of
        UIView.animate(withDuration: 0.5, animations: {
            self.darken.alpha = 0
            self.colourBtn.backgroundColor = self.colours[indexPath.row]
            self.colourPic.frame.origin.y = self.height
            
        }, completion: { (value: Bool) in
            self.darken.isHidden = false
        })
    }
}
