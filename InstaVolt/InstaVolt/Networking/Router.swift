//
//  Router.swift
//  InstaVolt
//
//  Created by PCQ111 on 11/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Alamofire
import Foundation

protocol Routable
{
    associatedtype T
    
    var path : String { get }
    var method : HTTPMethod { get }
    var parameters : Parameters? { get }
}


enum Router: Routable
{
    typealias T = Codable.Type
    
    case login(Parameters)
    case getDriverData
    case getDriverDetail(Parameters)
    case signUp(Parameters)
    case signUpPatch(Parameters)
    case updateDriverDetail(Parameters)
    case cancelDriverAccount
    case notifyChangePassword(Parameters)
    case getContactUs
    case getChargeStationOnMap(Parameters)
    case getAddressSuggestion(postcode: String, address: String)
    case getFilterOptions
    case checkReferralCode(referralCode: String)
}


extension Router
{
    var path : String
    {
        switch self
        {
        case .login:
            return Environment.APIBasePath() + "login/token"
        case .getDriverData:
            return Environment.APIBasePath() + "drivers/1"
        case .getDriverDetail:
            return Environment.APIBasePath() + "driver/detail"
        case .signUp:
            return Environment.APIBasePath() + "driver/signup"
        case .signUpPatch:
            return Environment.APIBasePath() + "driver"
        case .getContactUs:
            return Environment.APIBasePath() + "driver/contact-us"
        case .updateDriverDetail:
            return Environment.APIBasePath() + "driver"
        case .cancelDriverAccount:
            return Environment.APIBasePath() + "driver/cancel"
        case .notifyChangePassword:
            return Environment.APIBasePath() + "driver/notify-password-change"
        case .getChargeStationOnMap:
            return Environment.APIBasePath() + "location/charge-stations/search"
        case .getAddressSuggestion(let postcode, let address):
            return Environment.getAddressURL + "\(postcode)/\(address)" + "?api-key=9Ci5ABnjt0-VbXTgW9nZ7A26234"
        case .getFilterOptions:
            return Environment.APIBasePath() + "location/charge-stations/filter-menu"
        case .checkReferralCode(referralCode: let referralCode):
            return Environment.APIBasePath() + "driver/check-referral-code/\(referralCode)"
        }
    }
    
    
    var method : HTTPMethod
    {
        switch self
        {
        case .login:
            return .post
        case .getDriverData:
            return .get
        case .getDriverDetail:
            return .post
        case .signUp:
            return .post
        case .signUpPatch:
            return .patch
        case .getContactUs:
            return .get
        case .updateDriverDetail:
            return .put
        case .cancelDriverAccount:
            return .delete
        case .notifyChangePassword:
            return .put
        case .getChargeStationOnMap:
            return .post
        case .getAddressSuggestion:
            return .get
        case .getFilterOptions:
            return .get
        case .checkReferralCode:
            return .get
        }
    }
    
    
    var parameters : Parameters?
    {
        switch self
        {
        case .login(let param):
            return param
        case .getDriverData:
            return nil
        case .getDriverDetail(let param):
            return param
        case .signUp(let param):
            return param
        case .signUpPatch(let param):
        return param
        case .getContactUs:
            return nil
        case .updateDriverDetail(let param):
            return param
        case .cancelDriverAccount:
            return nil
        case .notifyChangePassword(let param):
            return param
        case .getChargeStationOnMap(let param):
            return param
        case .getAddressSuggestion:
            return nil
        case .getFilterOptions:
            return nil
        case .checkReferralCode:
            return nil
        }
    }
}
