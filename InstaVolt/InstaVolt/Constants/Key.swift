//
//  Key.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct Key
{
    //A
    static let authorization = "Authorization"
    //D
    static let dontShowSignUpAlertForGuest = "DontShowSignUpAlertForGuest"
    //U
    static let userType = "UserType"
    
    //Login View Controller -
    static let deviceId         = "device_id"
    static let deviceName       = "device_name"
//    static let ipAddress        = "ip_address"
    static let platformType     = "platform_type"
    
    static let firstName         = "first_name"
    static let lastName          = "last_name"
    static let email             = "email"
    static let referrerCode      = "referrer_code"
    static let providerKey       = "provider_key"
    
    //P
    
    static let password = "Password"

     
     //Profile View Controller -
     static let address          = "address"
     static let billingAddress   = "billing_address"
     
    //L
    static let loginType = "LoginType"
    
    //Map Listing Controller
    static let currentLatitude = "current_latitude"
    static let currentLongitude = "current_longitude"
    static let limit    = "limit"
    static let offset = "offset"
    static let status = "status"
    static let amenities = "amenities"
    static let distance = "distance"
    static let connectors = "connectors"
    static let power_types = "power_types"
    static let isListView = "isListView"
    static let start = "start"
    static let end = "end"
    static let searchLatitude = "search_latitude"
    static let searchLongitude = "search_longitude"
}
