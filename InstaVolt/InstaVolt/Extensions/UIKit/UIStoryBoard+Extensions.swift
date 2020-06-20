//
//  UIStoryBoard+Extensions.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    func getTabBarController<T: UITabBarController>(identifire: String) -> T {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: identifire)) as? T else {
            fatalError(String(describing: identifire) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
    
    func getNavigationController<T: UINavigationController>(identifire: String) -> T {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: identifire)) as? T else {
            fatalError(String(describing: identifire) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
    
    func getViewController<T: UIViewController>(type: T.Type) -> T {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError(String(describing: T.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
}
