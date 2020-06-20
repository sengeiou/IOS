//
//  DriverDetail.swift
//  InstaVolt
//
//  Created by PCQ177 on 31/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct DriverDetail: Codable
{
    let email           : Generic?
    let sub             : Generic?
    let emailVerified   : Generic?
    
   enum CodingKeys: String, CodingKey {
        case email          = "email"
        case sub            = "sub"
        case emailVerified  = "email_verified"
    
    }
}
