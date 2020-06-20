//
//  ContactUs.swift
//  InstaVolt
//
//  Created by PCQ177 on 28/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

class ContactUs: Codable
{
    let message : Generic?
    let data    : ContactUsDetail?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
    }
}
class ContactUsDetail: Codable
{
    let phone: Generic?
    let email: Generic?
    let address: Generic?
    let faqURL: Generic?
    
    enum CodingKeys: String, CodingKey
    {
        case phone = "phone"
        case email = "email"
        case address = "address"
        case faqURL = "faq_url"
    }
}
