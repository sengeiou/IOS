//
//  Constants.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import MobileCoreServices

typealias failure = ( _ failure: WebError,  _ detail:ErrorResponse?) -> Void

let UserDefault     = UserDefaults.standard
var filterCategoryArray: [FilterCategory] = []
var filterSubCategory  : FilterSubCategory?
var userDetail          : Driver?
var distance: [String: Any] = [:]
var status: [String] = []
var amenities: [String] = []
var power_types: [String] = []
var connectors: [String] = []
var isFilterApply: Bool = false

extension String
{
    struct Title
    {
        static let title            = "InstaVolt"
        static let doNotShowAgain   = "Do not show this again"
        static let ok               = "Ok"
        static let yes              = "Yes"
        static let no               = "No"
        static let wantToSignInOrUp = "You are not signed in the app? Do you want to Sign up/ Sign In?"
        static let errorMessage     = "Sorry! There were some technical issuses while fetching data"
        static let quit             = "Quit"
        static let retry            = "Retry"
        static let emptyFirstName   = "First name is required."
        static let validFirstName   = "First name is invalid."
        static let emptyLastName    = "Last name is required. "
        static let validLastName    = "Last name is invalid."
        static let emptyEmail       = "Email address is required."
        static let validEmail       = "Email address is invalid."
        static let emptyPassword    = "Password is required."
        static let acceptTermsAndCondition = "Please accept Terms and Conditions"
        static let validPassword    = "Please enter valid password."
        static let emptyOldPassword     = "Please enter old password."
        static let emptyNewPassword     = "New password is required."
        static let emptyReTypePassword  = "Confirmation of password is required."
        static let incorrectPassword = "Oops! You have entered wrong password."
        static let invalidReTypePassword = "Confirm password must match with a new password you have entered."
        static let passwordChanged     = "Password has been successfully changed"
        static let emptyAddress        = "Personal address information is required. "
        static let emptyBillingAddress = "Billing address information is required. "
        static let signInInfoNotETSupported     = "Sign In needs info which is not et supported."
        static let emptyOTP   = "OTP is required."
        static let cancelAccountString  = "Deleting your account will permanently remove all of your data from our system. Do you still want to continue ?"
        static let emptyCode = "Please enter a code which you received via email."
        static let emptyRetypePassword = "Confirmation of password is required."
        static let pullToRefresh = "Pull to refresh"
        static let invalidAddress = "Addresses does not found."
        static let invalidPostcode = "Post code or address are invalid."
        static let inValidReferralCode = "Sorry! Your Referral code is invalid"
        static let noStationWithSearch = "No stations found with your search text."
        static let noStationWithFilter = "No stations found with your selected filters."
        static let emailExist = "Email address which you have entered is already exists."
        static let invalidCode = "Oops! You have entered invalid code."
    }
    
    struct Label
    {
        static let email                 = "Email Address"
        static let password              = "Password"
        
    }
    
    struct Identifier
    {
        static let loginNavigationController   = "loginNavigationController"
        static let mainNavigationController    = "mainNavigationController"
        static let profileNavigationController = "profileNavigationController"
        static let settingNavigationController = "settingNavigationController"
        static let faqNavigationController = "FAQNavigationController"
        static let paymentNavigationController = "paymentNavigationController"
    }
    
    struct URL
    {
        static let termsAndConditonURL = "https://driver.dev.emsp.instavolt.co.uk/terms-and-condition.html"
    }
}

func mimeTypeForPath(path : String) -> String
{
    let url = NSURL(fileURLWithPath : path)
    let pathExtension = url.pathExtension
    
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
        if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
            return mimetype as String
        }
    }
    return "application/octet-stream"
}

func callGetFilterAPI()
{
    SettingController.shared.getFilterOption(successCompletion: { (filterCategory) in
        filterSubCategory = filterCategory
        prepareFilterVariable()
    }) { (error, errorResponse) in
        
    }
}

func prepareFilterVariable()
{
    filterCategoryArray.append(FilterCategory.init(id: 1, name: "Distance", subCategoryArray: filterSubCategory?.data?.distance ?? []))
    filterCategoryArray.append(FilterCategory.init(id: 2, name: "Status", subCategoryArray: filterSubCategory?.data?.status ?? []))
    filterCategoryArray.append(FilterCategory.init(id: 3, name: "Amenities", subCategoryArray: filterSubCategory?.data?.amenities ?? []))
    filterCategoryArray.append(FilterCategory.init(id: 4, name: "Charging Power", subCategoryArray: filterSubCategory?.data?.power_types ?? []))
    filterCategoryArray.append(FilterCategory.init(id: 5, name: "Connectors", subCategoryArray: filterSubCategory?.data?.connector_types ?? []))
    filterCategoryArray.append(FilterCategory.init(id: 6, name: "Network", subCategoryArray: filterSubCategory?.data?.network ?? []))
    let _ = filterCategoryArray.map({$0.isSelected = false})
    filterCategoryArray[0].isSelected = true
}

enum SideBarItemType: Int {
    case none            = 0
    case profile         = 1
    case findStation     = 2
    case payment         = 3
    case faqs            = 4
    case contactus       = 5
    case signIn          = 6
}
