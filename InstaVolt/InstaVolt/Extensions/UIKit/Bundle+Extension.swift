//
//  Bundle+Extension.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import UIKit

extension Bundle
{
    static func loadNib<T:UIViewController>(_ identifier : T.Type) -> T?
    {
        return T.init(nibName: String(describing: identifier), bundle: nil)
    }
}


extension Bundle
{
    private var releaseVersionNumber : String
    {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    private var buildVersionNumber : String
    {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
    var displayAppVersion : String
    {
        return "Version \(releaseVersionNumber) (\(buildVersionNumber))"
    }
}
