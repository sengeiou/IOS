//
//  DriverDetailsJSON.swift
//  InstaVolt
//
//  Created by PCQ111 on 29/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct JSONObjectDriver {
    static let DriverDetails: [String: Any] = [
        "message":"Driver details data fetch successful",
        "data": [
            "id" : 1,
            "first_name": "janvi",
            "last_name": "golani",
            "email" : "janvigolani@gmail.com",
            "address": "2101 Treasure Hills Blvd",
            "billing_address" : "2101 Treasure Hills Blvd #APT 622 Harlingen, Texas(TX), 785550",
            "status": [
                "id" : 1,
                "name": "janvigo",
                "reference_id": "2101 Treasure",
            ],
            "is_profile_verified": true
        ]
    ]
    
    static let cancelDriverAccount: [String: Any] = [
        "message" : "Driver account deleted successfully"
    ]
    
    static let updateDriverData: [String: Any] = [
        "message" : "Driver data updated successfully",
        "data"    : "[1]"
    ]
    
    static let changePasswordData: [String: Any] = [
        "message" : "Password reset successfully",
        "data"    : "[1]"
    ]
}
