//
//  APITestUtils.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 02/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
class APITestUtils
{
    func getMockData(file : String) -> Dictionary<String, Any>
    {
        let bundle = Bundle(for : type(of : self))
        if let path = bundle.path(forResource: file, ofType: "json")
        {
            do
            {
                let data = try Data(contentsOf : URL(fileURLWithPath : path), options : .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with : data, options : .mutableLeaves)
                return jsonResult as! [String: Any]
            } catch {
                fatalError("Service plist fetching failed, this should never happen")
            }
        }
        return [String:Any]()
    }
}
