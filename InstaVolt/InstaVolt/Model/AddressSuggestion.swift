//
//  AddressSuggestion.swift
//  InstaVolt
//
//  Created by PCQ177 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct AddressSuggestion: Codable
{
    let latitude    : Generic?
    let longitude   : Generic?
    let addresses   : [Generic]?
    
    enum CodingKeys: String,CodingKey
    {
        case latitude = "latitude"
        case longitude = "longitude"
        case addresses = "addresses"
    }
}
