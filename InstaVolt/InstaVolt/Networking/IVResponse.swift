//
//  IVResponse.swift
//  InstaVolt
//
//  Created by PCQ111 on 11/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable
{
    let message    : Generic?
    var code       : Generic?
    let Message    : Generic?

    enum CodingKeys: String, CodingKey
    {
        case message = "message"
        case Message = "Message"
    }
    
    init(from decoder: Decoder) throws
    {
        let values  = try decoder.container(keyedBy: CodingKeys.self)
        message   = try values.decodeIfPresent(Generic.self, forKey: .message)
        Message = try values.decodeIfPresent(Generic.self, forKey: .Message)
    }
}

struct SuccessRespose: Codable
{
    let success: Generic?
   
    enum CodingKeys: String, CodingKey
    {
        case status = "status"
    }
    init(status: String) {
        self.success = Generic(status)
    }
    init(from decoder: Decoder) throws
    {
       let values  = try decoder.container(keyedBy: CodingKeys.self)
       success   = try values.decodeIfPresent(Generic.self, forKey: .status)
    }
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy : CodingKeys.self)
        try container.encode(success, forKey: .status)
    }
}
