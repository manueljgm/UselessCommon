//
//  UIImage.swift
//  Common
//
//  Created by Manny Martins on 5/19/16.
//  Copyright © 2016 Useless Robot. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func imageWithInsets(_ insets: UIEdgeInsets) -> UIImage {
        
        let imageSize = CGSize(width: self.size.width + insets.left + insets.right, height: self.size.height + insets.top + insets.bottom)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithInsets!
        
    }
    
}
