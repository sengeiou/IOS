//
//  RegisterOTPViewController.swift
//  InstaVolt
//
//  Created by PCQ111 on 20/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import TextFieldEffects
import AWSMobileClient
import IQKeyboardManagerSwift

class RegisterOTPViewController: BaseViewController
{
    //Mark:- Outlets -
    @IBOutlet weak var btnDone                      : UIButton!
    @IBOutlet weak var btnResend                    : UIButton!
    @IBOutlet var txtTapGesture                     : UITapGestureRecognizer!
    @IBOutlet weak var stackViewContainingtxtOtp    : UIStackView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet var txtOtp                            : HoshiTextField!
    
    
    //MARK:- Variables -
    var emailPreString = "To complete signup, please enter the code we sent to "
    var otp: String = ""
    var email:String?
    var password:String?
    
    var isFromLoginScreen : Bool?
    var isOPTVerifiedFromLoginScreen : Bool = true
    var driverDetails: DriverResponse?
    var driverDataForSignUp: DriverData?
    var tempsignUpResponse: SignUpResponse?
    
    //MARK:- Life Cycle Methods -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.prepareOTPController()
        
        if(isFromLoginScreen == true)
        {
            resendOTP()
        }
    }
    
    //MARK:- View Methods -
    private func prepareOTPController()
    {
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        let firstAttributedString = NSMutableAttributedString(string: emailPreString)
        let attributedFormat = [ NSAttributedString.Key.foregroundColor: UIColor(red: 0.717, green: 0.196, blue: 0.177, alpha: 1.0)]
        firstAttributedString.append(NSAttributedString(string: email ?? "", attributes: attributedFormat))
        labelEmail.attributedText = firstAttributedString
    }
    
    //MARK:- Action Methods -
    @IBAction func done(_ sender: Any)
    {
        if validateOTPForm()
        {
            confirmSignUpAPICall()
        }
    }
    
    @IBAction func resendOTP(_ sender: UIButton)
    {
        resendOTP()
    }
    
    //MARK:- Custom Methods -
    
    private func validateOTPForm() -> Bool
    {
        if txtOtp.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyOTP,withActions: {
                self.txtOtp.becomeFirstResponder()
            })
            return false
        }
        return true
    }
    
    private func resendOTP()
    {
        //resend otp
        if let email = email {
            AWSMobileClient.default().resendSignUpCode(username: email, completionHandler: { (result, error) in
                if let signUpResult = result
                {
                    DispatchQueue.main.async {
                        self.showAlert(message: "A verification code has been sent via \(signUpResult.codeDeliveryDetails!.deliveryMedium) at \(signUpResult.codeDeliveryDetails!.destination!)")
                    }
                }
                else if let error = error as? AWSMobileClientError
                {
                    DispatchQueue.main.async {
                        switch error {
                        case .codeDeliveryFailure(message: let message):
                            self.showAlert(message: message)
                        case .internalError(message: let message):
                            self.showAlert(message: message)
                        case .invalidLambdaResponse(message: let message):
                            self.showAlert(message: message)
                        case .invalidParameter(message: let message):
                            self.showAlert(message: message)
                        case .limitExceeded(message: let message):
                            self.showAlert(message: message)
                        case .notAuthorized(message: let message):
                            self.showAlert(message: message)
                        case .tooManyRequests(message: let message):
                            self.showAlert(message: message)
                        case .userNotFound(message: let message):
                            self.showAlert(message: message)
                        default:
                            self.showAlert(message: String.Title.errorMessage)
                        }
                    }
                }
            })
        }
    }
    
    func awsLogin()
    {
        AWSMobileClient.default().signOut()
        print("********API CALL********")
        AWSMobileClient.default().signIn(username: email!, password: password!) { (signInResult, error) in
            
            if let error = error
            {
                if let error = error as? AWSMobileClientError
                {
                    self.stopLoading()
                    DispatchQueue.main.async {
                        switch error {
                        case .usernameExists(let message):
                            self.showValidationMessage(withMessage: message)
                        case .notAuthorized(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .invalidParameter(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .userNotFound(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .internalError(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .invalidPassword(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .limitExceeded(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .userNotConfirmed(message: let message):
                            self.showValidationMessage(withMessage: message)
                        default:
                            self.showValidationMessage(withMessage: String.Title.errorMessage)
                        }
                    }
                }
                print("\(error.localizedDescription)")
            }
            else if let signInResult = signInResult
            {
                switch (signInResult.signInState)
                {
                case .signedIn:
                    debugPrint("User is signed in.")
                    self.getAWSCognitoUser()
                    
                case .smsMFA:
                    self.stopLoading()
                    debugPrint("SMS message sent to \(signInResult.codeDetails!.destination!)")
                default:
                    self.stopLoading()
                    DispatchQueue.main.async
                        {
                            self.showValidationMessage(withMessage: String.Title.signInInfoNotETSupported)
                    }
                }
            }
        }
    }
    
    func getAWSCognitoUser()
    {
        //Get AWS cognito User
        AWSMobileClient.default().getUserAttributes { (user ,error) in
            
            if let user = user
            {
                debugPrint(user)
                let jsonData = (try? JSONSerialization.data(withJSONObject: user))!
                let driverData = try? JSONDecoder().decode(DriverData.self, from: jsonData)
                
                //Get User Token
                if let driverDataObj = driverData
                {
                    self.getAWSTokenForInstaVoltLogin(driverDataObj: driverDataObj)
                }
            }
            else if let error = error
            {
                if let error = error as? AWSMobileClientError
                {
                    self.stopLoading()
                    DispatchQueue.main.async {
                        switch error {
                        case .usernameExists(let message):
                            self.showValidationMessage(withMessage: message)
                        case .notAuthorized(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .invalidParameter(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .userNotFound(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .internalError(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .invalidPassword(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .limitExceeded(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .userNotConfirmed(message: let message):
                            self.showValidationMessage(withMessage: message)
                        default:
                            self.showValidationMessage(withMessage: String.Title.errorMessage)
                        }
                    }
                }
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func getAWSTokenForInstaVoltLogin(driverDataObj:DriverData)
    {
        //Get User Token
        AWSMobileClient.default().getTokens{ (token ,error) in
            
            if let token = token
            {
                debugPrint(token)
                
                //token store to keychain
                if let tokenString = token.accessToken?.tokenString
                {
                    KeyChainManager.shared.saveAccessToken(token: tokenString as NSString)
                }
                
                //add token to header
                if let token = KeyChainManager.shared.loadAccessToken()
                {
                    APIManager.API.header["Authorization"] = token as String
                }
                else
                {
                    KeyChainManager.shared.clearAccessToken()
                }
                
                //store password to keychain
                if let password = self.password
                {
                    KeyChainManager.shared.savePassword(password: password as NSString)
                }
                
                
                //store user to user default (Driver data to user defaults)
                DriverManager.setDriverOtherData(driver: driverDataObj)
                
                //store user type to user default
                let userType:UserType = .driver
                print(userType.rawValue)
                UserDefault[Key.userType] = userType.rawValue
                
                //store login type to user default
                let loginType : LoginType = .instaVolt
                print(loginType.rawValue)
                UserDefault[Key.loginType] = loginType.rawValue
                
                
                if(self.isFromLoginScreen == true && self.isOPTVerifiedFromLoginScreen == true)
                {
                    self.driverDetailAPICall()
                }
                else
                {
                    //sign up with provider key API call
                    self.signUpAPICall(email: self.email ?? "", providerKey: driverDataObj.sub?.stringValue ?? "")
                }
            }
            else if let error = error
            {
                if let error = error as? AWSMobileClientError
                {
                    DispatchQueue.main.async {
                        switch error {
                        case .usernameExists(let message):
                            self.showValidationMessage(withMessage: message)
                        case .notAuthorized(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .invalidParameter(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .userNotFound(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .internalError(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .invalidPassword(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .limitExceeded(message: let message):
                            self.showValidationMessage(withMessage: message)
                        case .userNotConfirmed(message: let message):
                            self.showValidationMessage(withMessage: message)
                        default:
                            self.showValidationMessage(withMessage: String.Title.errorMessage)
                        }
                    }
                }
                print("\(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK :- Sign Up API Call
    func signUpAPICall(email: String, providerKey: String)
    {
        let parameters = [
            Key.email         : email,
            Key.providerKey   : providerKey
        ]
        
        debugPrint(parameters)
        
        //Call Sign up API
        DriverController.shared.signUpWithPatch(parameters: parameters, successCompletion:
            { (signUpResponse) in
                
                self.stopLoading()
                
                //store driver other data to user default
                let driverData = DriverData(email: Generic(email), sub: Generic(providerKey), emailVerified: Generic(true))
                
                DriverManager.setDriverOtherData(driver: driverData)
                
                //store user type to user default
                let userType:UserType = .driver
                print(userType.rawValue)
                UserDefault[Key.userType] = userType.rawValue
                
                    //store login type to user default
                    let loginType : LoginType = .instaVolt
                    print(loginType.rawValue)
                    UserDefault[Key.loginType] = loginType.rawValue
                
                
                //API call for Driver details
                self.driverDetailAPICall()
        })
        { (error, resError) in
            self.stopLoading()
            self.showAPIerror(error: error, resError: resError)
            {
                //Our sign up API call on retry button
                if let providerKey = self.driverDataForSignUp?.sub?.stringValue
                {
                    self.signUpAPICall(email: email,
                                       providerKey: providerKey)
                }
            }
        }
        
        
        
        //temp code starts
        //        let jsonData = (try? JSONSerialization.data(withJSONObject: SignUpJSON.signUpJSON))!
        //        tempsignUpResponse = try? JSONDecoder().decode(SignUpResponse.self, from: jsonData)
        //
        //        //store driver other data to user default
        //        let driverData = DriverData(email: Generic(email), sub: Generic(providerKey), emailVerified: Generic(true))
        //
        //        DriverManager.setDriverOtherData(driver: driverData)
        //
        //        //store user type to user default
        //        let userType:UserType = .driver
        //        print(userType.rawValue)
        //        UserDefault[Key.userType] = userType.rawValue
        //
//                              //store login type to user default
//                               let loginType : LoginType = .instaVolt
//                               print(loginType.rawValue)
//                               UserDefault[Key.loginType] = loginType.rawValue
//
//
        //        //API call for Driver details
        //        self.driverDetailAPICall()
        //temp code ends
    }
    
    //MARK :- Driver details API Call(our backend API to get driver details)
    func driverDetailAPICall()
    {
        let parameters = [
            Key.deviceId     : Device.uniqueIdentifier, // Unique device id
            Key.deviceName   : Device.deviceName,
//            Key.ipAddress    : Device.getIPAddress(),
            Key.platformType : "iOS"
        ]
        
        debugPrint(parameters)
        
        //Call driver detail API
        self.startLoading()
        DriverController.shared.getDriverDetails(parameters: parameters, successCompletion: { (driverResponse) in
            print(driverResponse)
            self.stopLoading()
            self.driverDetails = driverResponse
            
            //user details store to user default
            if let driverData = self.driverDetails?.data
            {
                DriverManager.set(driver: driverData)
                userDetail = driverData
                //in success of that move to appropriate screen
                if(driverData.is_profile_verified?.boolValue == true) //profile details are filled
                {
                    DispatchQueue.main.async
                        {
                            self.moveToHomeScreen()
                    }
                }
                else //if not then move to profile screen
                {
                    DispatchQueue.main.async
                        {
//                            self.moveToProfileScreen()
                        IVApplication.shared.moveToProfileScreen()
                    }
                }
                print(driverData.first_name?.stringValue ?? "")
                self.stopLoading()
            }
        }) { (error, resError) in
            print(error)
            print(resError)
            self.stopLoading()
            self.showAPIerror(error: error, resError: resError) {
                self.driverDetailAPICall()
            }
        }
        
        
        //temp code starts
        //        let jsonData = (try? JSONSerialization.data(withJSONObject: JSONObjectDriver.DriverDetails))!
        //        driverDetails = try? JSONDecoder().decode(DriverResponse.self, from: jsonData)
        //        print(driverDetails)
        //
        //        //user details store to user default
        //        if let driverData = driverDetails?.data
        //        {
        //            DriverManager.set(driver: driverData)
        //
        //            //in success of that move to appropriate screen
        //            if(driverData.is_profile_verified?.boolValue == true) //profile details are filled
        //            {
        //                DispatchQueue.main.async
        //                    {
        //                        self.moveToHomeScreen()
        //                }
        //            }
        //            else //if not then move to profile screen
        //            {
        //                DispatchQueue.main.async
        //                    {
        //                        self.moveToProfileScreen()
        //                }
        //            }
        //
        //        }
        //temp code ends
    }
    
    private func confirmSignUpAPICall()
    {
        self.startLoading()
        if let email = self.email
        {
            AWSMobileClient.default().confirmSignUp(username: email, confirmationCode: txtOtp.text!)
            { (signUpResult, error) in
                if let signUpResult = signUpResult
                {
                    switch(signUpResult.signUpConfirmationState) {
                    case .confirmed:
                        print("User is signed up and confirmed.")
                            //AWS Sign in API call
                            self.awsLogin()
                    case .unconfirmed:
                        print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                    case .unknown:
                        print("Unexpected case")
                    }
                }
                else if let error = error
                {
                    if let error = error as? AWSMobileClientError
                    {
                        DispatchQueue.main.async {
                            switch error {
                            case .usernameExists(let message):
                                self.showValidationMessage(withMessage: message)
                            case .notAuthorized(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .invalidParameter(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .userNotFound(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .internalError(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .invalidPassword(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .limitExceeded(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .userNotConfirmed(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .codeMismatch(message: let message):
                                self.showValidationMessage(withMessage: String.Title.invalidCode)
                            case .expiredCode(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .tooManyRequests(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .tooManyFailedAttempts(message: let message):
                                self.showValidationMessage(withMessage: message)
                            default:
                                self.showValidationMessage(withMessage: String.Title.errorMessage)
                            }
                        }
                    }
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
}

//MARK:- Navigations Methods -
extension RegisterOTPViewController
{
//    func moveToProfileScreen()
//    {
//        if let profileScreen = R.storyboard.profile.profileViewController()
//        {
//            profileScreen.shouldHideCancelButton = true
//            profileScreen.shouldHideCancelAccount = true
//            profileScreen.shouldHideForgotPassword = true
//            profileScreen.isFromSignUp = true
//            navigationController?.pushViewController(profileScreen, animated: true)
//        }
//    }
    
    func moveToHomeScreen()
    {
        let mainViewController = MainSideBarViewController()
        let mapViewController = R.storyboard.main().getNavigationController(identifire: String.Identifier.mainNavigationController)
        mainViewController.rootViewController = mapViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
}
