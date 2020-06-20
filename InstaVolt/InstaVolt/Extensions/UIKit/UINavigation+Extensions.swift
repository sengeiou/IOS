//
//  UINavigation+Extensions.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        if let popController = viewControllers.filter({ $0.isKind(of: viewController)}).first {
            popToViewController(popController, animated: true)
        }
    }
    
    func controllerIsPresent(viewController: Swift.AnyClass) -> Bool {
        var checkController = false
        if viewControllers.filter({ $0.isKind(of: viewController)}).first != nil {
            checkController = true
        }
        return checkController
    }
}
