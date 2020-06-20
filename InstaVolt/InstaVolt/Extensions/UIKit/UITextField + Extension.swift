//
//  UITextField + Extension.swift
//  InstaVolt
//
//  Created by PCQ177 on 04/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import UIKit

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    
    //Max Length
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
    @IBInspectable var placeHolderColor : UIColor?
        {
        get
        {
            return self.placeHolderColor
        }
        set
        {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
extension UITextField
{
    @IBInspectable var leftImage: UIImage? {
        set {
            if let image = newValue {
                leftViewMode = UITextField.ViewMode.always
                let view = UIView(frame: CGRect(x: 0.0, y: 0, width: 20.0, height: 20.0))
                let imageView = UIImageView(frame: CGRect(x: 5.0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
                imageView.contentMode = .center
                imageView.image = image
                view.addSubview(imageView)
                view.isUserInteractionEnabled = false
                // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
                leftView = view
            }
        }
        get
        {
           return UIImage()
        }
    }
}
