//
//  collectionViewExt.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 11/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

extension homeVC {
    
    //setting the size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //check if it;s the 7th cell
        if indexPath.row % 7 == 0 {
            return CGSize(width: width, height: width)
        } else {
            //keep trying and check how much must be minused before its divisible by 3
            for i in 1 ... 3 {
                //set smaller cell size
                small = (width - CGFloat(i))/3
                //cheking
                if (width - CGFloat(i)).truncatingRemainder(dividingBy: 3) == 0 {
                    return CGSize(width: small, height: small)
                }
            }
        }
        
        return CGSize(width: width, height: width)
    }
    
    //spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //keep trying and check how much must be minused before its divisible by 3
        for i in 1 ... 3 {
            //find cell size
            if (width - CGFloat(i)).truncatingRemainder(dividingBy: 3) == 0 {
                //find cell spacing form the amount needed to minus
                return CGFloat(i)/3
            }
        }
        return 0
    }
    
    //spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //keep trying and check how much must be minused before its divisible by 3
        for i in 1 ... 3 {
            //find cell size
            if (width - CGFloat(i)).truncatingRemainder(dividingBy: 3) == 0 {
                //find cell spacing form the amount needed to minus
                return CGFloat(i)/3 * 2
            }
        }
        return 0
    }
    
    //number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            //display searched products
            return searchedImg.count
        }
        
        //display all
        return images.count
    }
    
    //set up cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! homeCVC
        
        var image = UIImage()
        
        //deteremined whichimage to choose searched/all
        if searching {
            image = self.searchedImg[indexPath.row]
        } else {
            image = self.images[indexPath.row]
        }
        
        //declaring variables to make image square
        var x = CGFloat()
        var y = CGFloat()
        var imgWidth = CGFloat()
        var imgHeight = CGFloat()
        
        //image portrait or landscape
        if image.size.width > image.size.height {
            y = 0
            //check if it is big cell or small
            if indexPath.row % 7 == 0 {
                imgHeight = width
                //using ratio to find width
                imgWidth = width/image.size.height * image.size.width
                x = (width - imgWidth)/2
            } else {
                imgHeight = small
                //using ratio to find width
                imgWidth = small/image.size.height * image.size.width
                x = (small - imgWidth)/2
            }
        } else {
            x = 0
            //check if it is big cell or small
            if indexPath.row % 7 == 0 {
                imgWidth = width
                //using ratio to find height
                imgHeight = width/image.size.width * image.size.height
                y = (width - imgHeight)/2
            } else {
                imgWidth = small
                //using ratio to find height
                imgHeight = small/image.size.width * image.size.height
                y = (small - imgHeight)/2
            }
        }
        
        //set imgView to required size
        cell.img.frame = CGRect(x: x, y: y, width: imgWidth, height: imgHeight)
        cell.img.image = image
        
        return cell
    }
}
