//
//  DateFormatter+Extension.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

extension DateFormatter
{
    static let  dateFormater : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    
    static let dateFormaterLongWithMiliSecond : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    
    static let dateFormatterTime : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
  
    
    static let eventAPIDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy, hh:mm:ss a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
