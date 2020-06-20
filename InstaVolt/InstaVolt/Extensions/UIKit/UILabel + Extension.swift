//
//  UILabel + Extension.swift
//  InstaVolt
//
//  Created by PCQ177 on 05/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import UIKit

extension UILabel
{
    func countLabelLines() -> Int {
        let myText = self.text! as NSString
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font!], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}
