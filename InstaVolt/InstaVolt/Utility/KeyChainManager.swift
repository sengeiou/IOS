import UIKit
import Foundation
import Security


// Constant Identifiers
let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"


/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

class KeyChainManager: NSObject {
    
    static let shared = KeyChainManager()
    
    private static let ACCESS_TOKEN_KEY              = "ACCESS_TOKEN_KEY" + (Bundle.main.bundleIdentifier ?? "")
    
    private static let PASSWORD_KEY              = "PASSWORD_KEY"
    
    //---------------------------------ACCESS_TOKEN_KEY----------------------------------------------------------
    public func clearAccessToken(){
        self.saveAccessToken(token: "");
    }
    public func saveAccessToken(token: NSString) {
        self.save(service: KeyChainManager.ACCESS_TOKEN_KEY as NSString, data: token)
    }
    public func loadAccessToken() -> NSString? {
        return self.load(service: KeyChainManager.ACCESS_TOKEN_KEY as NSString)
    }
    
    //---------------------------------PASSWORD_KEY----------------------------------------------------------
    public func clearPassword(){
        self.savePassword(password: "");
    }
    public func savePassword(password: NSString) {
        self.save(service: KeyChainManager.PASSWORD_KEY as NSString, data: password)
    }
    public func loadPassword() -> NSString? {
        return self.load(service: KeyChainManager.PASSWORD_KEY as NSString)
    }
    
    
    

    /**
     * Internal methods for querying the keychain.
     */
    
    private func save(service: NSString, data: NSString) {
        let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue,
                                                                               service,
                                                                               userAccount,
                                                                               dataFromString],
                                                                     forKeys: [kSecClassValue,
                                                                               kSecAttrServiceValue,
                                                                               kSecAttrAccountValue,
                                                                               kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private func load(service: NSString) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue,
                                                                               service,
                                                                               userAccount,
                                                                               kCFBooleanTrue,
                                                                               kSecMatchLimitOneValue],
                                                                     forKeys: [kSecClassValue,
                                                                               kSecAttrServiceValue,
                                                                               kSecAttrAccountValue,
                                                                               kSecReturnDataValue,
                                                                               kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
    
//    class func updatePassword(service: String, account:String, data: String) {
//        if let dataFromString: Data = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
//
//            // Instantiate a new default keychain query
//            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
//
//            let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue:dataFromString] as CFDictionary)
//
//            if (status != errSecSuccess) {
//                if let err = SecCopyErrorMessageString(status, nil) {
//                    print("Read failed: \(err)")
//                }
//            }
//        }
//    }
//
//
//    class func removePassword(service: String, account:String) {
//
//        // Instantiate a new default keychain query
//        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
//
//        // Delete any existing items
//        let status = SecItemDelete(keychainQuery as CFDictionary)
//        if (status != errSecSuccess) {
//            if #available(iOS 11.3, *) {
//                if let err = SecCopyErrorMessageString(status, nil) {
//                    print("Remove failed: \(err)")
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//
//    }
}


