//
//  TempDriver.swift
//  InstaVolt
//
//  Created by PCQ111 on 13/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

struct TempDriverResponse: Codable {
    let message: Generic?
    let data: TempDriver?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
        
    }
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(Generic.self, forKey: .message)
        data = try values.decodeIfPresent(TempDriver.self, forKey: .data)
    }
}

struct TempDriver : Codable
{
	let id : Generic?
	let firstName : Generic?
	let lastName : Generic?
	let email : Generic?
	let defaultLanguageId : Generic?
	let providerKey : Generic?
	let otp : Generic?
	let otpTimeStamp : Generic?
	let totalFailedAttempt : Generic?
	let statusId : Generic?
	let locked : Generic?
	let lastLogin : Generic?
	let lastPasswordChange : Generic?
	let defaultDashboardId : Generic?
	let createdBy : Generic?
	let modifiedBy : Generic?
	let createdDate : Generic?
	let modifiedDate : Generic?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case firstName = "firstName"
		case lastName = "lastName"
		case email = "email"
		case defaultLanguageId = "defaultLanguageId"
		case providerKey = "providerKey"
		case otp = "otp"
		case otpTimeStamp = "otpTimeStamp"
		case totalFailedAttempt = "totalFailedAttempt"
		case statusId = "statusId"
		case locked = "locked"
		case lastLogin = "lastLogin"
		case lastPasswordChange = "lastPasswordChange"
		case defaultDashboardId = "defaultDashboardId"
		case createdBy = "createdBy"
		case modifiedBy = "modifiedBy"
		case createdDate = "createdDate"
		case modifiedDate = "modifiedDate"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        
		id = try values.decodeIfPresent(Generic.self, forKey: .id)
		firstName = try values.decodeIfPresent(Generic.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(Generic.self, forKey: .lastName)
		email = try values.decodeIfPresent(Generic.self, forKey: .email)
		defaultLanguageId = try values.decodeIfPresent(Generic.self, forKey: .defaultLanguageId)
		providerKey = try values.decodeIfPresent(Generic.self, forKey: .providerKey)
		otp = try values.decodeIfPresent(Generic.self, forKey: .otp)
		otpTimeStamp = try values.decodeIfPresent(Generic.self, forKey: .otpTimeStamp)
		totalFailedAttempt = try values.decodeIfPresent(Generic.self, forKey: .totalFailedAttempt)
		statusId = try values.decodeIfPresent(Generic.self, forKey: .statusId)
		locked = try values.decodeIfPresent(Generic.self, forKey: .locked)
		lastLogin = try values.decodeIfPresent(Generic.self, forKey: .lastLogin)
		lastPasswordChange = try values.decodeIfPresent(Generic.self, forKey: .lastPasswordChange)
		defaultDashboardId = try values.decodeIfPresent(Generic.self, forKey: .defaultDashboardId)
		createdBy = try values.decodeIfPresent(Generic.self, forKey: .createdBy)
		modifiedBy = try values.decodeIfPresent(Generic.self, forKey: .modifiedBy)
		createdDate = try values.decodeIfPresent(Generic.self, forKey: .createdDate)
		modifiedDate = try values.decodeIfPresent(Generic.self, forKey: .modifiedDate)
	}
    
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy : CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(defaultLanguageId, forKey: .defaultLanguageId)
        try container.encode(providerKey, forKey: .providerKey)
        try container.encode(otp, forKey: .otp)
        try container.encode(otpTimeStamp, forKey: .otpTimeStamp)
        try container.encode(totalFailedAttempt, forKey: .totalFailedAttempt)
        
        try container.encode(statusId, forKey: .statusId)
        try container.encode(locked, forKey: .locked)
        try container.encode(lastLogin, forKey: .lastLogin)
        
        try container.encode(lastPasswordChange, forKey: .lastPasswordChange)
        try container.encode(defaultDashboardId, forKey: .defaultDashboardId)
        try container.encode(createdBy, forKey: .createdBy)
        
        try container.encode(modifiedBy, forKey: .modifiedBy)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(modifiedDate, forKey: .modifiedDate)
    }

}
