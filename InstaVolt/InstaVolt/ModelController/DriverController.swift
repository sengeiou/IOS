//
//  DriverController.swift
//  InstaVolt
//
//  Created by PCQ111 on 15/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

final class DriverController {
    
    static let shared: DriverController = DriverController()
    
    /// driver details

    func getDriverDetails(parameters: [String:Any],successCompletion: @escaping (_ response: DriverResponse) -> Void,
    failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void){
        APIManager.API.sendRequest(.getDriverDetail(parameters), type: DriverResponse.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
    
    /// sign up api
    func signUp(parameters: [String:Any],successCompletion: @escaping (_ response: SignUpResponse) -> Void,
    failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void){
        APIManager.API.sendRequest(.signUp(parameters), type: SignUpResponse.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
    
    /// sign up api with patch
    func signUpWithPatch(parameters: [String:Any],successCompletion: @escaping (_ response: SignUpResponse) -> Void,
    failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void){
        APIManager.API.sendRequest(.signUpPatch(parameters), type: SignUpResponse.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
    
    func updateDriverDetail(parameters: [String:Any],successCompletion: @escaping (_ response: UpdateDriver) -> Void,
    failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void){
        APIManager.API.sendRequest(.updateDriverDetail(parameters), type: UpdateDriver.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
    
    func cancelDriverAccount(successCompletion: @escaping (_ response: SuccessMessage) -> Void,
    failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void){
        APIManager.API.sendRequest(.cancelDriverAccount, type: SuccessMessage.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
    
    func notifyPasswordChanged(parameters: [String:Any],successCompletion: @escaping (_ response: SuccessMessage) -> Void,
    failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void){
        APIManager.API.sendRequest(.notifyChangePassword(parameters), type: SuccessMessage.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
    
    func checkReferralCode(referralCode: String,successCompletion: @escaping (_ response: SuccessMessage) -> Void,
       failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void){
           APIManager.API.sendRequest(.checkReferralCode(referralCode: referralCode), type: SuccessMessage.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
       }
}
