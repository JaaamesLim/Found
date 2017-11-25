//
//  colourExtension.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 13/11/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
