//
//  ProjectLog.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

public func plog<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    if Environment.debug {
        let value = object()
        let fileURL = URL(fileURLWithPath: file)
        let checkThread  = Thread.isMainThread ? "UI" : "BG"
        print("**************************************************")
        print("<\(checkThread)> \(fileURL) \(function)[\(line)]: \n" + String(reflecting: value))
        print("**************************************************")
    }
}
