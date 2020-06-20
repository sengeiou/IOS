//
//  UIColor+Extension.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    static let applicationLightBlueColor = UIColor.init(hexString : "009DDC")
    
    static let rgb = { (red : CGFloat, green : CGFloat, blue : CGFloat, alpha : CGFloat) -> UIColor in
        return UIColor(red:red / 255.0, green:green / 255.0, blue:blue / 255.0, alpha:alpha)
    }
    
    
    convenience init(hexString : String)
    {
        let hex = hexString.trimmingCharacters(in : CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string : hex).scanHexInt32(&int)
        let a, r, g, b : UInt32
        switch hex.count
        {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default : 
            (a, r, g, b) = (0, 0, 0, 0)
        }
        self.init(red : CGFloat(r) / 255, green : CGFloat(g) / 255, blue : CGFloat(b) / 255, alpha : CGFloat(a) / 255)
    }
    
    
    static func colorWithRGB(red : CGFloat, green : CGFloat, blue : CGFloat, alpha : CGFloat) -> UIColor
    {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}
