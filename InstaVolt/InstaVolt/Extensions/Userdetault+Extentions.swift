//
//  Userdetault+Extentions.swift
//  InstaVolt
//
//  Created by PCQ111 on 20/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

extension UserDefaults {
    /// SwifterSwift: get object from UserDefaults by using subscript
    ///
    /// - Parameter key: key in the current user's defaults database.
    subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            set(newValue, forKey: key)
        }
    }
    
    static func contains(key: String) -> Bool {
        return self.standard.contains(key: key)
    }
    
    func contains(key: String) -> Bool {
        return self.dictionaryRepresentation().keys.contains(key)
    }
    
    func reset() {
        for key in Array(UserDefaults.standard.dictionaryRepresentation().keys) {
            UserDefaults.standard.removeObject(forKey: key)
            let ingnoreKeys: [String] = []//Application scope keys
            if ingnoreKeys.contains(key) {
                continue
            }
            
        }
        synchronize()
    }
    
    /// SwifterSwift: Retrieves a Codable object from UserDefaults.
    ///
    /// - Parameters:
    /// - type: Class that conforms to the Codable protocol.
    /// - key: Identifier of the object.
    /// - decoder: Custom JSONDecoder instance. Defaults to `JSONDecoder()`.
    /// - Returns: Codable object for key (if exists).
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    /// SwifterSwift: Allows storing of Codable objects to UserDefaults.
    ///
    /// - Parameters:
    /// - object: Codable object to store.
    /// - key: Identifier of the object.
    /// - encoder: Custom JSONEncoder instance. Defaults to `JSONEncoder()`.
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        set(data, forKey: key)
    }
}
