//
//  RegisterViewController.swift
//  InstaVolt
//
//  Created by PCQ111 on 14/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import AWSMobileClient
import TextFieldEffects

class RegisterViewController: BaseViewController
{
    //MARK:- Outlets -
    @IBOutlet weak var txtFirstName                 : UITextField!
    @IBOutlet weak var txtLastName                  : UITextField!
    @IBOutlet weak var txtEmail                     : UITextField!
    @IBOutlet weak var txtPassword                  : HoshiTextField!
    @IBOutlet weak var txtReferralCode              : UITextField!
    @IBOutlet weak var buttonLogin                  : UIButton!
    @IBOutlet weak var buttonSignUp                 : UIButton!
    @IBOutlet weak var buttonFaceBookSignUp         : UIButton!
    @IBOutlet weak var buttonGoogleSignUp           : UIButton!
    @IBOutlet weak var buttonCheckBox               : UIButton!
    @IBOutlet weak var upperViewHeightConstraint    : NSLayoutConstraint!
    
    @IBOutlet weak var referralCodeVerifiedButton: UIButton!
    //MARK:- Variables -
    var driverDetails: DriverResponse?
    var driverDataForSignUp: DriverData?
    var tempsignUpResponse: SignUpResponse?
    var isReferralCodeValid: Bool = false
    
    private var passwordValidationButton : UIButton = {
        let buttonEye = UIButton(frame : CGRect(x : 0, y : 0, width : 40, height : 40))
        buttonEye.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
        buttonEye.setImage(#imageLiteral(resourceName: "eyeSelected"), for : .selected)
        buttonEye.setImage(#imageLiteral(resourceName : "eye"), for : .normal)
        buttonEye.addTarget(self, action : #selector(onClickButtonEye(_ : )), for : .touchUpInside)
        return buttonEye
    }()
    
    //MARK:- Life Cycle Methods -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.prepareRegistrationView()
    }
    
    //MARK:- View Methods -
    private func prepareRegistrationView()
    {
        self.setUpPasswordTextfield(passwordTextField : txtPassword)
        referralCodeVerifiedButton.isHighlighted = false
        referralCodeVerifiedButton.isSelected = true
        if UIScreen.main.bounds.height > 800 {
            upperViewHeightConstraint.constant  = 229.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        txtFirstName.text = ""
        txtLastName.text = ""
        txtEmail.text = ""
        txtPassword.text = ""
        txtReferralCode.text = ""
        buttonCheckBox.isSelected = false
        
        //        txtFirstName.resignFirstResponder()
        //        txtLastName.resignFirstResponder()
        //        txtEmail.resignFirstResponder()
        //        txtPassword.resignFirstResponder()
        //        txtReferralCode.resignFirstResponder()
        
    }
    
    //MARK:- Action Methods -
    
    @IBAction func didTapOnReferralCode(_ sender: UIButton) {
        if sender.isSelected
        {
            self.showAlert(message: String.Title.inValidReferralCode)
        }
    }
    
    
    @IBAction func login(_ sender: Any)
    {
        var didPop = false
        for controller in navigationController?.viewControllers ?? []
        {
            if controller.isKind(of: LoginViewController.self) {
                let loginVC = controller as! LoginViewController
                didPop = true
                navigationController?.popToViewController(loginVC, animated: true)
            }
        }
        if didPop == false
        {
            moveToLoginScreen()
        }
    }
    
    @IBAction func signUp(_ sender: Any)
    {
        if validateRegisterForm()
        {
            awsSignUpAPICall()
        }
    }
    
    @IBAction func facebookSignUp(_ sender: Any)
    {
        awsFacebookSignUpAPICall(isFaceBook: true)
    }
    
    @IBAction func googleSignUp(_ sender: Any)
    {
        awsFacebookSignUpAPICall(isFaceBook: false)
    }
    
    @IBAction func termsAndConditions(_ sender: UIButton)
    {
        if let termsAndConditionVC = R.storyboard.login.termsAndConditionViewController()
        {
            termsAndConditionVC.modalPresentationStyle = .overFullScreen
            termsAndConditionVC.modalTransitionStyle = .crossDissolve
            termsAndConditionVC.termsAndConditionDelegate = self
            self.present(termsAndConditionVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapOnTermsAndConditionCheckbox(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
    }
    
    //MARK:- Objective Methods -
    @objc private func onClickButtonEye(_ sender : UIButton)
    {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        sender.isSelected = !txtPassword.isSecureTextEntry
    }
    
    //MARK:-  Custom Methods -
    
    private func setUpPasswordTextfield(passwordTextField : HoshiTextField)
    {
        let container = UIView(frame : passwordValidationButton.frame)
        container.backgroundColor = .clear
        container.addSubview(passwordValidationButton)
        
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = container
    }
    
    private func validateRegisterForm() -> Bool
    {
        if txtFirstName.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyFirstName,withActions: {
                self.txtFirstName.becomeFirstResponder()
            })
            return false
        }
        else if txtFirstName.text?.trim().isValidName == false
        {
            self.showValidationMessage(withMessage: String.Title.validFirstName,withActions: {
                self.txtFirstName.becomeFirstResponder()
            })
            return false
        }
        else if txtLastName.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyLastName,withActions: {
                self.txtLastName.becomeFirstResponder()
            })
            return false
        }
        else if txtLastName.text?.trim().isValidName == false
        {
            self.showValidationMessage(withMessage: String.Title.validLastName,withActions: {
                self.txtLastName.becomeFirstResponder()
            })
            return false
        }
        else if txtEmail.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyEmail,withActions: {
                self.txtEmail.becomeFirstResponder()
            })
            return false
        }
        else if txtEmail.text?.isValidEmail == false
        {
            self.showValidationMessage(withMessage: String.Title.validEmail,withActions: {
                self.txtEmail.becomeFirstResponder()
            })
            return false
        }
        else if txtPassword.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyPassword,withActions: {
                self.txtPassword.becomeFirstResponder()
            })
            return false
        }
        else if buttonCheckBox.isSelected == false
        {
            showValidationMessage(withMessage: String.Title.acceptTermsAndCondition)
            return false
        }
        return true
    }
    
    //AWS sign up API call
    private func awsSignUpAPICall()
    {
        self.startLoading()
        AWSMobileClient.default().signUp(username: txtEmail.text!,password: txtPassword.text!,userAttributes: ["email":txtEmail.text!])
        { (signUpResult, error) in
            if let signUpResult = signUpResult
            {
                switch(signUpResult.signUpConfirmationState)
                {
                case .confirmed:
                    debugPrint("User is signed up and confirmed.")
                    self.stopLoading()
                case .unconfirmed:
                    debugPrint("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                    var referralCode: String = ""
                    if self.isReferralCodeValid
                        {
                            referralCode = self.txtReferralCode.text ?? ""
                    }
                        else
                        {
                                referralCode = ""
                    }
                    DispatchQueue.main.async
                        {
                            //Our sign up API call
                            if let firstName = self.txtFirstName.text, let lastName = self.txtLastName.text, let email = self.txtEmail.text
                            {
                                self.signUpAPICall(firstName: firstName,
                                                   lastName: lastName,
                                                   email: email,
                                                   referralCode: referralCode,
                                                   providerKey: "",
                                                   isAWSCall: true, loginType: 1)
                            }
                    }
                case .unknown:
                    print("Unexpected case")
                    self.stopLoading()
                }
            }
            else if let error = error
            {
                if let error = error as? AWSMobileClientError
                {
                    self.stopLoading()
                    DispatchQueue.main.async {
                        switch error {
                        case .usernameExists( _):
                             self.showValidationMessage(withMessage: String.Title.emailExist)
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
    
    func getAWSCognitoUser()
    {
        //Get AWS cognito User
        AWSMobileClient.default().getUserAttributes { (user ,error) in
            
            if let error = error
            {
                if let error = error as? AWSMobileClientError
                {
                    DispatchQueue.main.async {
                        switch error {
                        case .notSignedIn(let message):
                            self.showValidationMessage(withMessage: message)
                        case .usernameExists( _):
                            self.showValidationMessage(withMessage: String.Title.emailExist)
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
            else
            {
                debugPrint(user)
                
                let jsonData = (try? JSONSerialization.data(withJSONObject: user))!
                let driverData = try? JSONDecoder().decode(DriverData.self, from: jsonData)
                print(driverData)
                self.driverDataForSignUp = driverData
                
                //Get User Token
                self.getAWSTokenForInstaVoltLogin()
            }
        }
    }
    
    func getAWSTokenForInstaVoltLogin()
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
                if let password = self.txtPassword.text
                {
                    KeyChainManager.shared.savePassword(password: password as NSString)
                }
                    
                    DispatchQueue.main.async
                        {
                            //Our sign up API call
                            if let firstName = self.txtFirstName.text, let lastName = self.txtLastName.text, let email = self.txtEmail.text, let referralCode = self.txtReferralCode.text, let providerKey = self.driverDataForSignUp?.sub?.stringValue
                            {
                                self.signUpAPICall(firstName: firstName,
                                                   lastName: lastName,
                                                   email: email,
                                                   referralCode: referralCode,
                                                   providerKey: providerKey,
                                                   isAWSCall: true, loginType: 1)
                            }
                    }
                
            }
            else if let error = error
            {
                if let error = error as? AWSMobileClientError
                {
                    DispatchQueue.main.async {
                        switch error {
                        case .notSignedIn(let message):
                            self.showValidationMessage(withMessage: message)
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
    
    private func awsFacebookSignUpAPICall(isFaceBook:Bool)
    {
        AWSMobileClient.default().signOut()
        
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
            if let error = error
            {
                if let error = error as? AWSMobileClientError
                {
                    DispatchQueue.main.async {
                        switch error {
                        case .notSignedIn(let message):
                            self.showValidationMessage(withMessage: message)
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
            else if let userState = userState
            {
                print("Status: \(userState.rawValue)")
                if(isFaceBook)
                {
                    self.getAWSTokenForSocialLogin(loginType: 2)
                }
                else
                {
                    self.getAWSTokenForSocialLogin(loginType: 3)
                }
            }
        }
    }
    
    func getAWSTokenForSocialLogin(loginType:Int)
    {
        AWSMobileClient.default().getTokens { (tokens, error) in
            if let error = error
            {
                if let error = error as? AWSMobileClientError
                {
                    DispatchQueue.main.async {
                        switch error {
                        case .notSignedIn(let message):
                            self.showValidationMessage(withMessage: message)
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
                
                let claims = tokens.idToken?.claims
                
                if let email = claims?["email"] as? String, let userName = claims?["name"] as? String, let sub = claims?["sub"] as? String
                {
                    let fullNameArr = userName.components(separatedBy: " ")
                    
                    //Sign up for social login
                    self.signUpAPICall(firstName: fullNameArr[0], lastName: fullNameArr[1], email: email, referralCode: "", providerKey: sub, isAWSCall: false, loginType: loginType)
                }
            }
        }
    }
    
    //MARK :- Sign Up API Call
    func signUpAPICall(firstName: String, lastName: String, email: String, referralCode: String, providerKey: String, isAWSCall : Bool, loginType: Int)
    {
        self.startLoading()
        var parameters : [String:Any]
        if(isAWSCall == true) //sign up with aws
        {
            if(referralCode != "")
            {
                parameters = [
                    Key.firstName     : firstName,
                    Key.lastName      : lastName,
                    Key.email         : email,
                    Key.referrerCode  : referralCode
                ]
            }
            else
            {
                parameters = [
                    Key.firstName     : firstName,
                    Key.lastName      : lastName,
                    Key.email         : email
                ]
            }
        }
        else //social login
        {
            parameters = [
                Key.firstName     : firstName,
                Key.lastName      : lastName,
                Key.email         : email,
                Key.providerKey   : providerKey
            ]
        }
        
        debugPrint(parameters)
        
        //Call Sign up API
        DriverController.shared.signUp(parameters: parameters, successCompletion:
            { (signUpResponse) in
                
                print(signUpResponse)
                self.stopLoading()
                if(isAWSCall)
                {
                    DispatchQueue.main.async
                        {
                            //move to OPT screen
                            self.moveToRegisterOTPScreen()
                    }
                }
                else
                {
                    //store driver other data to user default
                    let driverData = DriverData(email: Generic(email), sub: Generic(providerKey), emailVerified: Generic(true))
                    
                    DriverManager.setDriverOtherData(driver: driverData)
                    
                    //store user type to user default
                    let userType:UserType = .driver
                    print(userType.rawValue)
                    UserDefault[Key.userType] = userType.rawValue
                    
                    if(loginType == 2)
                    {
                        //store login type to user default
                        let loginType : LoginType = .facebook
                        print(loginType.rawValue)
                        UserDefault[Key.loginType] = loginType.rawValue
                    }
                    else if(loginType == 3)
                    {
                        //store login type to user default
                        let loginType : LoginType = .google
                        print(loginType.rawValue)
                        UserDefault[Key.loginType] = loginType.rawValue
                    }
                    
                    //API call for Driver details
                    self.driverDetailAPICall()
                }
        })
        { (error, resError) in
            
            self.stopLoading()

            if(isAWSCall == true) //sign up with aws
            {
                self.showAPIerror(error: error, resError: resError)
                {
                    //Our sign up API call on retry button
                    if let firstName = self.txtFirstName.text, let lastName = self.txtLastName.text, let email = self.txtEmail.text, let referralCode = self.txtReferralCode.text, let providerKey = self.driverDataForSignUp?.sub?.stringValue
                    {
                        self.signUpAPICall(firstName: firstName,
                                           lastName: lastName,
                                           email: email,
                                           referralCode: referralCode,
                                           providerKey: providerKey,
                                           isAWSCall: true, loginType: loginType)
                    }
                }
            }
            else
            {
                //                self.showValidationMessage(withMessage: resError?.message?.stringValue)
                if let code = resError?.code?.intValue, code == 409 {
                    let driverData = DriverData(email: Generic(email), sub: Generic(providerKey), emailVerified: Generic(true))
                    
                    DriverManager.setDriverOtherData(driver: driverData)
                    
                    //store user type to user default
                    let userType:UserType = .driver
                    print(userType.rawValue)
                    UserDefault[Key.userType] = userType.rawValue
                    
                    
                    if(loginType == 2)
                    {
                        //store login type to user default
                        let loginType : LoginType = .facebook
                        print(loginType.rawValue)
                        UserDefault[Key.loginType] = loginType.rawValue
                    }
                    else if(loginType == 3)
                    {
                        //store login type to user default
                        let loginType : LoginType = .google
                        print(loginType.rawValue)
                        UserDefault[Key.loginType] = loginType.rawValue
                    }
                    
                    
                    //API call for Driver details
                    self.driverDetailAPICall()
                }
            }
        }
        
        
        //temp code starts
//                let jsonData = (try? JSONSerialization.data(withJSONObject: SignUpJSON.signUpJSON))!
//                tempsignUpResponse = try? JSONDecoder().decode(SignUpResponse.self, from: jsonData)
//
//                if(isAWSCall)
//                {
//                    DispatchQueue.main.async
//                    {
//                        //move to OPT screen
//                        self.moveToRegisterOTPScreen()
//                    }
//                }
//                else
//                {
//                    //store driver other data to user default
//                    let driverData = DriverData(email: Generic(email), sub: Generic(providerKey), emailVerified: Generic(true))
//
//                    DriverManager.setDriverOtherData(driver: driverData)
//
//                    //store user type to user default
//                    let userType:UserType = .driver
//                    print(userType.rawValue)
//                    UserDefault[Key.userType] = userType.rawValue
//

//                        //store login type to user default
//                        let loginType : LoginType = .social
//                        print(loginType.rawValue)
//                        UserDefault[Key.loginType] = loginType.rawValue
//                    //API call for Driver details
//                    self.driverDetailAPICall()
//                }
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
//                                    self.moveToProfileScreen()
                                    IVApplication.shared.moveToProfileScreen()
                            }
                        }
                        print(driverData.first_name?.stringValue ?? "")
                        self.stopLoading()
                    }
                }) { (error, resError) in
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
}

//MARK:- Navigations Methods -
extension RegisterViewController
{
    func moveToLoginScreen()
    {
        if let loginScreen = R.storyboard.login.loginViewController()
        {
            navigationController?.pushViewController(loginScreen, animated: true)
        }
    }
    
    func moveToRegisterOTPScreen()
    {
        if let registerOTPScreen = R.storyboard.login.registerOTPViewController()
        {
            //registerOTPScreen.driverDataForSignUp = self.driverDataForSignUp
            registerOTPScreen.password = txtPassword.text
            registerOTPScreen.email = txtEmail.text
            registerOTPScreen.isFromLoginScreen = false
            registerOTPScreen.email = self.txtEmail.text
            navigationController?.pushViewController(registerOTPScreen, animated: true)
        }
    }
    
    func moveToHomeScreen()
    {
        if let mapScreen = R.storyboard.main.mapViewController()
        {
            navigationController?.pushViewController(mapScreen, animated: true)
        }
    }
    
//    func moveToProfileScreen()
//    {
//        if let profileScreen = R.storyboard.profile.profileViewController()
//        {
//            profileScreen.isFromSignUp = true
//            profileScreen.shouldHideCancelButton = true
//            profileScreen.shouldHideCancelAccount = true
//            profileScreen.shouldHideForgotPassword = true
//            profileScreen.isFromLogin = true
//            navigationController?.pushViewController(profileScreen, animated: true)
//        }
//    }
}
//MARK:- UITextField Delegate Methods -
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName
        {
            txtLastName.becomeFirstResponder()
        }
        else if textField == txtLastName
        {
            txtEmail.becomeFirstResponder()
        }
        else if textField == txtEmail
        {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword
        {
            txtReferralCode.becomeFirstResponder()
        }
        else if textField == txtReferralCode
        {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == txtReferralCode
        {
            if textField.text != ""
            {
                self.startLoading()
                DriverController.shared.checkReferralCode(referralCode: textField.text!, successCompletion: { (_) in
                    self.stopLoading()
                    self.isReferralCodeValid = true
                    self.referralCodeVerifiedButton.isHidden = false
                    self.referralCodeVerifiedButton.isSelected = false
                    
                }) { (error, errorResponse) in
                    self.stopLoading()
                    self.isReferralCodeValid = false
                    self.referralCodeVerifiedButton.isHidden = false
                    self.referralCodeVerifiedButton.isSelected = true
                }
            }
        }
        return true
    }
}

//MARK:- TermsAndCondition Protocol
extension RegisterViewController: TermsAndCondition
{
    func acceptTermsAndCondition()
    {
        buttonCheckBox.isSelected = true
    }
    
    func declineTermsAndCondition()
    {
        buttonCheckBox.isSelected = false
    }
}
