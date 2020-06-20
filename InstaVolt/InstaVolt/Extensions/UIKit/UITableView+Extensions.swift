//
//  UITableView+Extensions.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerDeque<T: UITableViewCell>(type: T.Type, indexPath: IndexPath, _ isNibClass: Bool = true) -> T {
        if isNibClass { registerCell(type: type) }
        if let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T {
            return cell
        } else {
            return registerDeque(type: type, indexPath: indexPath, isNibClass)
        }
    }
    
    private func registerCell<T: UITableViewCell>(type: T.Type) {
        register(UINib(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: String(describing: T.self))
    }
    
}


