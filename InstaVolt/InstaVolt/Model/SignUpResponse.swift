//
//  SignUpResponse.swift
//  InstaVolt
//
//  Created by PCQ111 on 01/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct SignUpResponse : Codable {
    let message : Generic?

    enum CodingKeys: String, CodingKey {

        case message = "message"
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        message = try values.decodeIfPresent(Generic.self, forKey: .message)
//    }

}
