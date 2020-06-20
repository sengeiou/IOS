//
//  Driver.swift
//  InstaVolt
//
//  Created by PCQ111 on 29/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct DriverResponse : Codable {
    let message : Generic?
    let data : Driver?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case data = "data"
    }
}

struct Driver : Codable {
    let id : Generic?
    let first_name : Generic?
    let last_name : Generic?
    let email : Generic?
    let address : Generic?
    let billing_address : Generic?
    let status : Status?
    let is_profile_verified : Generic?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
        case address = "address"
        case billing_address = "billing_address"
        case status = "status"
        case is_profile_verified = "is_profile_verified"
    }
}
struct Status : Codable {
    let id : Generic?
    let name : Generic?
    let code : Generic?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case code = "code"
    }
}

