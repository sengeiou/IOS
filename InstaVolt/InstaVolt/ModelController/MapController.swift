//
//  MapController.swift
//  InstaVolt
//
//  Created by PCQ111 on 10/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

final class MapController {
    
    static let shared: MapController = MapController()
    
    /// getChargeStationsOnMap
    func getChargeStationsOnMap(parameters: [String:Any],successCompletion: @escaping (_ response: LocationResponse) -> Void,
    failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void)
    {
        APIManager.API.sendRequest(.getChargeStationOnMap(parameters), type: LocationResponse.self, successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
}
