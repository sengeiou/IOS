//
//  UserDefault.swift
//  InstaVolt
//
//  Created by PCQ111 on 14/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import Foundation

struct DriverManager
{
    static func set(driver : Driver?)
    {
        if let driver = driver
        {
            if let encodedData = try? JSONEncoder().encode(driver)
            {
                UserDefaults.standard.set(encodedData, forKey : "driverDefault")
            }
        }
        else
        {
            UserDefaults.standard.removeObject(forKey : "driverDefault")
        }
        UserDefaults.standard.synchronize()
    }
    
    
    static func driver() -> Driver?
    {
        if let driver = UserDefaults.standard.object(forKey: "driverDefault") as? Data
        {
            let decoder = JSONDecoder()
            if let storedUser = try? decoder.decode(Driver.self, from: driver)
            {
                return storedUser
            }
        }
        return nil
    }
    
    static func setDriverOtherData(driver : DriverData?)
    {
        if let driver = driver
        {
            if let encodedData = try? JSONEncoder().encode(driver)
            {
                UserDefaults.standard.set(encodedData, forKey : "driverOtherDataDefault")
            }
        }
        else
        {
            UserDefaults.standard.removeObject(forKey : "driverOtherDataDefault")
        }
        UserDefaults.standard.synchronize()
    }
    
    static func driverOtherData() -> DriverData?
    {
        if let driver = UserDefaults.standard.object(forKey: "driverOtherDataDefault") as? Data
        {
            let decoder = JSONDecoder()
            if let storedUser = try? decoder.decode(DriverData.self, from: driver)
            {
                return storedUser
            }
        }
        return nil
    }
}
