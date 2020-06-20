//
//  UpdateDriver.swift
//  InstaVolt
//
//  Created by PCQ177 on 31/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct UpdateDriver: Codable
{
    let message: Generic?
    let data: Generic?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data   = "data"
    }
}
