//
//  DriverData.swift
//  InstaVolt
//
//  Created by PCQ111 on 01/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct DriverData : Codable
{
    let email       : Generic?
    let emailVerified : Generic?
    let sub           : Generic?

    init(email: Generic,sub:Generic,emailVerified: Generic)
    {
        self.email = email
        self.sub = sub
        self.emailVerified = emailVerified
    }
    enum CodingKeys: String, CodingKey
    {

        case email = "email"
        case emailVerified = "email_verified"
        case sub = "sub"
    }
}



