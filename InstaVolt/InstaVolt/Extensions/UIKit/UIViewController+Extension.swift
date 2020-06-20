//
//  UIViewController+Extension.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController
{
    func showAlert(message : String, actions : [UIAlertAction] = [] )
    {
        let alertController = UIAlertController(title : String.Title.title, message : message, preferredStyle : .alert)
        
        if actions.count == 0
        {
            self.defaultAlertAction(alertController : alertController)
        }
        else
        {
            actions.forEach
            { (action) in
                alertController.addAction(action)
            }
        }
        self.present(alertController, animated : true)
    }
    
    func showValidationMessage(withMessage message: String?, preferredStyle: UIAlertController.Style = .alert, withActions actions: (()->Void)? = nil)
    {
        let alert = UIAlertController(title: String.Title.title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: String.Title.ok, style: .default, handler: { (_) in
            actions?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithError(error : WebError)
    {
        if let message = error.errorMessage
        {
            let alertController = UIAlertController(title : String.Title.title, message : message, preferredStyle : .alert)
            self.defaultAlertAction(alertController : alertController)
            self.present(alertController, animated : true)
        }
    }
   
    
    private func defaultAlertAction(alertController : UIAlertController)
    {
        alertController.addAction(UIAlertAction(title : String.Title.ok, style : .default, handler : { _ in
        }))
    }
    
    
    func showProgress()
    {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
    
    
    func dismissProgress()
    {
        SVProgressHUD.dismiss()
    }
    
    func getXIB<T:UIView>(type:T.Type) -> T
    {
        guard let XIB = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: [:])?.first as? T else {
            fatalError(String(describing: T.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return XIB
    }
}
