//
//  SettingController.swift
//  InstaVolt
//
//  Created by PCQ177 on 29/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

final class SettingController {
    
    static let shared: SettingController = SettingController()
    
    ///Contact Us API call
    func getContactUsDetail(successCompletion: @escaping (_ response: ContactUs) -> Void,
                            failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void){
        APIManager.API.sendRequest(.getContactUs, type: ContactUs.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
    
    func getFilterOption(successCompletion: @escaping (_ response: FilterSubCategory) -> Void,
                         failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void){
        APIManager.API.sendRequest(.getFilterOptions, type: FilterSubCategory.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
}
