//
//  ProfileController.swift
//  InstaVolt
//
//  Created by PCQ177 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

final class ProfileController {
    
    static let shared: ProfileController = ProfileController()
    
    ///Get Address
    func getAddressListing(postcode: String,address: String,successCompletion: @escaping (_ response: AddressSuggestion) -> Void,
                           failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void)
    {
        APIManager.API.sendRequest(.getAddressSuggestion(postcode: postcode, address: address), type: AddressSuggestion.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
    
}
