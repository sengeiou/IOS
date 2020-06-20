//
//  Device.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
//import MessageUI
import Alamofire

extension UIDevice
{
    var hasNotch: Bool
    {
        if #available(iOS 11.0, *)
        {
            let top = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return top > 0
        }
        else
        {
            // Fallback on earlier versions
            return false
        }
    }
}


final class Device
{
    class var isInTestFlight: Bool
    {
        // http://stackoverflow.com/questions/12431994/detect-testflight
        return Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true
    }
    
    class var screenWidth: CGFloat
    {
            return UIScreen.main.bounds.size.width
    }
    
    class var screenHeight: CGFloat
    {
        return UIScreen.main.bounds.size.height
    }
    
    class var type: String {
        return "1"
    }
    class var operatingSystem: String {
        return UIDevice.current.systemVersion
    }
    class var screenSize : CGSize {
        return UIScreen.main.bounds.size
    }
    
    class var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    class var isIphone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    class var iPhonePlusSize: CGSize {
        return CGSize(width: 414.0, height: 736.0)
    }
    
    class var uniqueIdentifier: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    class var deviceName : String {
        return UIDevice.current.name 
    }
    
    class var XHeight: CGFloat {
        return 812
    }
    class var iPhone6: CGFloat {
        return 812
    }
    class var iPhone5SSize: CGFloat {
        return 568
    }
    class var DefaultHeight: CGFloat {
        var height = (UIScreen.main.bounds.height * 42) / Device.XHeight
        if Device.isIphone {
            height = 42
        }
        if UIScreen.main.bounds.height == Device.iPhone5SSize {
            height = 35
        }
        return height
    }
    class var textFieldWidth: CGFloat {
        if Device.isIpad {
            return UIScreen.main.bounds.size.width - 160
        } else {
            return UIScreen.main.bounds.size.width - 30
        }
    }
    class var halfPercentage: CGFloat {
        return 10
    }
    class var zeroSize: CGFloat {
        return 0
    }
    class var negativeSize: CGFloat {
        if Device.isIpad {
            return 5
        }else{
            return -15
        }
    }
    class var midPercentage: CGFloat {
        return -15
    }
    class var topScaperSize: CGFloat {
        return 8
    }
    class var iPadTopParentSize: CGFloat {
        return 110
    }
    class var iPhoneTopParentSize: CGFloat {
        return 70
    }
    class var centreX: CGFloat {
        var centre = (UIScreen.main.bounds.height/2) - 310
        if centre < 0 {
            centre = 50
        }
        return centre
    }
    
    class var bottomConstraints: CGFloat {
        return (UIScreen.main.bounds.height * 40) / Device.iPhone6
    }
    
    class var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    class var isLandscape : Bool {
        //return UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        
        if isIpad {
            
        } else {
            if Device.screenSize.width > 414.0 {
                return true
            }
        }
        return false
    }
    
//    class var hasTopNotch: Bool {
//        if #available(iOS 11.0, tvOS 11.0, *) {
//            // with notch: 44.0 on iPhone X, XS, XS Max, XR.
//            // without notch: 20.0 on iPhone 8 on iOS 12+.
//            return Application.shared.window?.safeAreaInsets.top ?? 0 > 20
//        }
//        return false
//    }
    
    class var screenBrightness: Int {
        return Int(UIScreen.main.brightness * 100)
    }
    
    class var isReachable: Bool {
        let reachable = NetworkReachabilityManager()
        return reachable?.isReachable ?? false
    }
    
    class func hideKeyboard() {
        IQKeyboardManager.shared.resignFirstResponder()
    }
    
    /// It is used to move on setting
    class func openSettingsApp() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]
, completionHandler: nil)
    }
    
    /// Gets the identifier from the system, such as "iPhone7,1".
    private static var identifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
   class func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6),
                    let cString = interface?.ifa_name,
                    String(cString: cString) == "en0" || String(cString: cString) == "pdp_ip0",
                    let saLen = (interface?.ifa_addr.pointee.sa_len) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    let ifaAddr = interface?.ifa_addr
                    getnameinfo(ifaAddr,
                                socklen_t(saLen),
                                &hostname,
                                socklen_t(hostname.count),
                                nil,
                                socklen_t(0),
                                NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
            freeifaddrs(ifaddr)
        }
    return address ?? "1.1.1.1"
    }
    
}
