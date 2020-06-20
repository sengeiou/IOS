//
//  UIView+Extensions.swift
//  LearningIndia
//
//  Created by PCQ182 on 21/02/20.
//  Copyright © 2020 Narendra Pandey. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Top Corner Radius -
    @IBInspectable var topCornerRadius: CGFloat {
        set {
            DispatchQueue.main.async {
                self.roundCorners(corners: [.topLeft, .topRight], radius: newValue)
            }
        } get {
            return layer.borderWidth
        }
    }
    
    
    // MARK: - Top Corner Radius -
    @IBInspectable var bottomCornerRadius: CGFloat {
        set {
            DispatchQueue.main.async {
                self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: newValue)
            }
        } get {
            return layer.borderWidth
        }
    }
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    // MARK: - Add background Gradient -
    @IBInspectable var isBackgroundGradient: Bool {
        get {
            return self.isBackgroundGradient
        } set {
            if newValue {
                DispatchQueue.main.async {
                    self.setGradientBackground()
                }
            }
        }
    }
    
    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black, UIColor.gray]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Add Corner radius -
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        }set {
                DispatchQueue.main.async {
                    self.layer.cornerRadius = newValue
                    self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    //MARK: - Drop Shadow
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true){
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
    }
}

// MARK: - Get Parent Controller -
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
//    func addShadow(shadowColor: UIColor = UIColor.black) {
//        layer.shadowRadius  = 8.0
//        layer.shadowColor   = shadowColor.cgColor
//        layer.shadowOffset  = CGSize(width: 2, height: 2)
//        layer.shadowOpacity = 1.0
//        layer.masksToBounds = false
//    }
    
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "backgroudLayer"
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    func removeGradient() {
        if self.layer.sublayers?.indices.contains(0) ?? false, self.layer.sublayers?[0].name == "backgroudLayer" {
            self.layer.sublayers?.remove(at: 0)
        }
    }

    func shake(for duration: TimeInterval = 0.5, withTranslation translation: CGFloat = 10) {
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3) {
            self.transform = CGAffineTransform(translationX: translation, y: 0)
        }
        
        propertyAnimator.addAnimations({
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.2)
        
        propertyAnimator.startAnimation()
    }
}


enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.9, radius: CGFloat = 11.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: -10, height: 10), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.9, radius: CGFloat = 11.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
