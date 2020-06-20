//
//  User.swift
//  InstaVolt
//
//  Created by PCQ111 on 13/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct User : Codable
{
    let accessToken : Generic?
    let tokenType : Generic?
    let userName : Generic?
    let expiresIn : Generic?
    let refreshToken : Generic?
    let scope : Generic?
    let sessionId : Generic?
    let consumerUid : Generic?
    let appKey : Generic?
    
    var apiUserName : String
    {
        return self.userName?.stringValue.replacingOccurrences(of: "tpcx\\", with: "").uppercased() ?? ""
    }
    
    enum CodingKeys: String, CodingKey
    {
        case accessToken = "AccessToken"
        case tokenType = "TokenType"
        case userName = "UserName"
        case expiresIn = "ExpiresIn"
        case refreshToken = "RefreshToken"
        case scope = "Scope"
        case sessionId = "SessionId"
        case consumerUid = "ConsumerUid"
        case appKey = "AppKey"
    }
    
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try values.decodeIfPresent(Generic.self, forKey: .accessToken)
        tokenType = try values.decodeIfPresent(Generic.self, forKey: .tokenType)
        userName = try values.decodeIfPresent(Generic.self, forKey: .userName)
        expiresIn = try values.decodeIfPresent(Generic.self, forKey: .expiresIn)
        refreshToken = try values.decodeIfPresent(Generic.self, forKey: .refreshToken)
        scope = try values.decodeIfPresent(Generic.self, forKey: .scope)
        sessionId = try values.decodeIfPresent(Generic.self, forKey: .sessionId)
        consumerUid = try values.decodeIfPresent(Generic.self, forKey: .consumerUid)
        appKey = try values.decodeIfPresent(Generic.self, forKey: .appKey)
    }

    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy : CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(tokenType, forKey: .tokenType)
        try container.encode(userName, forKey: .userName)
        try container.encode(expiresIn, forKey: .expiresIn)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(scope, forKey: .scope)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(consumerUid, forKey: .consumerUid)
        try container.encode(appKey, forKey: .appKey)
    }
}


struct UserResponse: Codable
{
    let data: User?
    let statusCode: Generic?
    let message: Generic?
    
    enum CodingKeys: String, CodingKey
    {
        case data = "Data"
        case statusCode = "StatusCode"
        case message = "Message"
    }
    
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Generic.self, forKey: .statusCode)
        message = try values.decodeIfPresent(Generic.self, forKey: .message)
        data = try values.decodeIfPresent(User.self, forKey: .data)
    }
    
}
