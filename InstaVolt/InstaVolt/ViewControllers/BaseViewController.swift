//
//  BaseViewController.swift
//  InstaVolt
//
//  Created by PCQ111 on 14/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import SVProgressHUD
import AWSMobileClient

class BaseViewController: UIViewController
{
    var unauthorizedCount = 0
    
    //MARK:- Life Cycle Methods -
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK:- View Methods -
    func showCustomNavigationBar()
    {
        let navigationBar  = getXIB(type: AppNavigationBar.self)
        
        if UIDevice.current.hasNotch
        {
            navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 94)
        }
        else
        {
            navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64)
        }
        self.view.addSubview(navigationBar)
    }
    
    //MARK:- Custom Methods -
    func showAPIerror(error: WebError,resError: ErrorResponse?, retry: @escaping() -> Void)
    {
        SVProgressHUD.dismiss()
        
        let actionQuit = UIAlertAction(title: String.Title.quit, style: UIAlertAction.Style.default, handler: nil)
        let actionRetry = UIAlertAction(title: String.Title.retry, style: UIAlertAction.Style.default) { (_) in
            
            self.callUnAuthoriseToken(error: error) { (_) in
                
                DispatchQueue.main.async
                    {
                        retry()

                }
            }
        }
        if let message = resError?.message?.stringValue
        {
            print(message)
            if(resError?.code?.intValue == 401)
            {
                showAlert(message: message, actions: [actionQuit,actionRetry])
            }
            else
            {
                showAlert(message: message, actions: [actionQuit])
            }
        }
        else
        {
            showAlert(message: error.errorMessage ?? "", actions: [actionQuit,actionRetry])
        }
    }
    
    func callUnAuthoriseToken(error: WebError, complition: @escaping(_ success: Bool) -> Void)
    {
        
        if let error = error as? WebError
        {
            self.stopLoading()
            DispatchQueue.main.async {
                switch(error)
                {
                case .unknown:
                    if(self.unauthorizedCount == 0)
                    { // API CAll login aws
                        
                        let userType = UserDefault[Key.loginType] as? Int
                        
                        if userType == 1
                        {
                            self.awsLoginForToken(complition: complition)
                        }
                        else if userType == 2
                        {
                            self.awsFacebookSignUpAPICallForToken(isFaceBook: true, complition: complition)
                        }
                        else if userType == 3
                        {
                            self.awsFacebookSignUpAPICallForToken(isFaceBook: false, complition: complition)
                        }
                    }
                    else
                    {
                        // dont call api
                    }
                    
                default:
                    complition(true)
                }
            }
        }
        
        
        
        //        if (error.errorMessage ?? "") == "You are not authorised."
        //        {
        //            if(unauthorizedCount == 0)
        //            { // API CAll login aws
        //
        //                let userType = UserDefault[Key.loginType] as? Int
        //
        //                if userType == 1
        //                {
        //                    self.awsLoginForToken(complition: complition)
        //                }
        //                else if userType == 2
        //                {
        //                    awsFacebookSignUpAPICallForToken(isFaceBook: true, complition: complition)
        //                }
        //                else if userType == 3
        //                {
        //                    awsFacebookSignUpAPICallForToken(isFaceBook: false, complition: complition)
        //                }
        //            }
        //            else
        //            {
        //                // dont call api
        //            }
        //        }
        //        else
        //        {
        //            complition(true)
        //        }
    }
    
    func startLoading()
    {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }
    
    func stopLoading()
    {
        SVProgressHUD.dismiss()
    }
    
    private func awsFacebookSignUpAPICallForToken(isFaceBook:Bool, complition: @escaping(_ success: Bool) -> Void)
    {
        AWSMobileClient.default().signOut() //temp
        
        var identity : String = ""
        
        if isFaceBook == true
        {
            identity = "Facebook"
        }
        else
        {
            identity = "Google"
        }
        
        // Optionally override the scopes based on the usecase.
        let hostedUIOptions = HostedUIOptions(scopes: ["openid", "email","profile"], identityProvider: identity)
        
        // Present the Hosted UI sign in.
        AWSMobileClient.default().showSignIn(navigationController: self.navigationController!, hostedUIOptions: hostedUIOptions)
        { (userState, error) in
            if let error = error as? AWSMobileClientError
            {
                DispatchQueue.main.async
                    {
                        self.showValidationMessage(withMessage: error.localizedDescription)
                }
            }
            if let userState = userState
            {
                print("Status: \(userState.rawValue)")
                self.getAWSTokenForSocialLoginForUnauthorized(complition: complition)
            }
        }
    }
    
    func getAWSTokenForSocialLoginForUnauthorized(complition: @escaping(_ success: Bool) -> Void
    )
    {
        AWSMobileClient.default().getTokens { (tokens, error) in
            if let error = error
            {
                DispatchQueue.main.async
                    {
                        self.showValidationMessage(withMessage: error.localizedDescription)
                }
            }
            else if let tokens = tokens
            {
                print(tokens.idToken ?? "")
                
                //token store to keychain
                if let tokenString = tokens.accessToken?.tokenString
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
                self.unauthorizedCount += 1
                complition(true)
            }
        }
    }
    
    func awsLoginForToken(complition: @escaping(_ success: Bool) -> Void)
    {
        self.startLoading()
        AWSMobileClient.default().signOut()
        
        if let passWord = KeyChainManager.shared.loadPassword()
        {
            AWSMobileClient.default().signIn(username: DriverManager.driverOtherData()?.email?.stringValue ?? "", password: passWord as String) { (signInResult, error) in
                
                if let error = error
                {
                    if let error = error as? AWSMobileClientError
                    {
                        self.stopLoading()
                        DispatchQueue.main.async {
                            switch(error)
                            {
                            case .userNotConfirmed(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .codeMismatch(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .expiredCode(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .internalError(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .invalidLambdaResponse(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .invalidParameter(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .limitExceeded(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .notAuthorized(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .resourceNotFound(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .tooManyRequests(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .unexpectedLambda(message: let message):
                                self.showValidationMessage(withMessage: message)
                                
                            case .userNotFound(message: let message):
                                self.showValidationMessage(withMessage: message)
                            case .invalidPassword(message: let message):
                                self.showValidationMessage(withMessage: message)
                            default:
                                self.showValidationMessage(withMessage: error.localizedDescription)
                            }
                        }
                    }
                }
                else if let signInResult = signInResult
                {
                    switch (signInResult.signInState)
                    {
                    case .signedIn:
                        debugPrint("User is signed in.")
                        DispatchQueue.main.async {
                            self.getAWSCognitoUserForToken(complition: complition)
                        }
                    case .smsMFA:
                        debugPrint("SMS message sent to \(signInResult.codeDetails!.destination!)")
                    default:
                        DispatchQueue.main.async
                            {
                                self.showValidationMessage(withMessage: String.Title.signInInfoNotETSupported)
                        }
                    }
                }
            }
        }
    }
    
    func getAWSCognitoUserForToken(complition: @escaping(_ success: Bool) -> Void)
    {
        //Get AWS cognito User
        AWSMobileClient.default().getUserAttributes { (user ,error) in
            debugPrint(user)
            
            if let user = user
            {
                let jsonData = (try? JSONSerialization.data(withJSONObject: user))!
                let driverData = try? JSONDecoder().decode(DriverData.self, from: jsonData)
                print(driverData)
                
                //Get User Token
                DispatchQueue.main.async {
                    if let driverDataObj = driverData
                    {
                        self.getAWSTokenForInstaVoltLoginForToken(driverDataObj: driverDataObj, complition: complition)
                    }
                }
            }
        }
    }
    
    func getAWSTokenForInstaVoltLoginForToken(driverDataObj:DriverData,complition: @escaping(_ success: Bool) -> Void)
    {
        //Get User Token
        AWSMobileClient.default().getTokens{ (token ,error) in
            debugPrint(token ?? "")
            
            //token store to keychain
            if let tokenString = token?.accessToken?.tokenString
            {
                KeyChainManager.shared.saveAccessToken(token: tokenString as NSString)
            }
            
            if let token = KeyChainManager.shared.loadAccessToken()
            {
                APIManager.API.header["Authorization"] = token as String
            }
            else
            {
                KeyChainManager.shared.clearAccessToken()
            }
            self.unauthorizedCount += 1
            complition(true)
        }
    }
}
