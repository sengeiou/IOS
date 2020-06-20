//
//  LoginViewController.swift
//  InstaVolt
//
//  Created by PCQ111 on 14/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import TextFieldEffects
import AWSMobileClient
import SkyFloatingLabelTextField

class LoginViewController: BaseViewController
{
    //MARK:- Outlets -
    @IBOutlet weak var buttonForgotPassword : UIButton!
    @IBOutlet weak var buttonSignIn         : UIButton!
    @IBOutlet weak var buttonSignUp         : UIButton!
    @IBOutlet weak var txtEmail             : HoshiTextField!
    @IBOutlet weak var txtPassword          : HoshiTextField!
    
    var driverDetails: DriverResponse?
    var tempsignUpResponse: SignUpResponse?
    
    //MARK:- Variables -
    var tempProfileDetailsFilled : Bool = false
    
    private var userNameValidationButton : UIButton = {
        let buttonTick = UIButton(frame : CGRect(x : 0, y : 0, width : 40, height : 40))
        buttonTick.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
        buttonTick.isUserInteractionEnabled = false
        buttonTick.setImage(#imageLiteral(resourceName: "email_verified"), for : .selected)
        return buttonTick
    }()
    
    private var passwordValidationButton : UIButton = {
        let buttonEye = UIButton(frame : CGRect(x : 0, y : 0, width : 40, height : 40))
        buttonEye.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
        buttonEye.setImage(#imageLiteral(resourceName: "eyeSelected"), for : .selected)
        buttonEye.setImage(#imageLiteral(resourceName : "eye"), for : .normal)
        buttonEye.addTarget(self, action : #selector(onClickButtonEye(_ : )), for : .touchUpInside)
        return buttonEye
    }()
    
    //MARK:- Lifecycle Methods -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        prepareLoginView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        txtPassword.text = ""
    }
    
    //MARK:- View Methods -
    private func prepareLoginView()
    {
        self.setUpEmailTextfield(userNameTextField : txtEmail)
        self.setUpPasswordTextfield(passwordTextField : txtPassword)
    }
    
    //MARK:- Webservice Methods -
    
    //MARK:- Action Methods -
    @IBAction func forgotPasword(_ sender: Any)
    {
        moveToForgotPasswordScreen()
    }
    
    @IBAction func signIn(_ sender: Any)
    {
        if validateLoginForm()
        {
            awsLogin()
        }
    }
    
    @IBAction func signUp(_ sender: Any)
    {
        var didPop = false
        for controller in navigationController?.viewControllers ?? []
        {
            if controller.isKind(of: RegisterViewController.self)
            {
                let registerVC = controller as! RegisterViewController
                didPop = true
                navigationController?.popToViewController(registerVC, animated: true)
            }
        }
        if didPop == false
        {
            moveToRegisterScreen()
        }
    }
    
    @IBAction func faceBook(_ sender: Any)
    {
        awsFacebookSignUpAPICall(isFaceBook: true)
    }
    
    @IBAction func google(_ sender: Any)
    {
        awsFacebookSignUpAPICall(isFaceBook: false)
    }
    
    //MARK:- Objective Methods -
    @objc private func onClickButtonEye(_ sender : UIButton)
    {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        sender.isSelected = !txtPassword.isSecureTextEntry
    }
    
    //MARK:- Custom Methods -
    private func setUpEmailTextfield(userNameTextField : HoshiTextField)
    {
        
        let container = UIView(frame : userNameValidationButton.frame)
        container.backgroundColor = .clear
        container.addSubview(userNameValidationButton)
        
        userNameTextField.rightViewMode = .always
        userNameTextField.rightView = container
    }
    
    private func setUpPasswordTextfield(passwordTextField : HoshiTextField)
    {
        let container = UIView(frame : passwordValidationButton.frame)
        container.backgroundColor = .clear
        container.addSubview(passwordValidationButton)
        
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = container
    }
    
    //Validation Method -
    private func validateLoginForm() -> Bool
    {
        if txtEmail.text?.trim().count == 0
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
        return true
    }
    
    func awsLogin()
    {
        self.startLoading()
        AWSMobileClient.default().signOut()
        AWSMobileClient.default().signIn(username: txtEmail.text ?? "", password: txtPassword.text ?? "") { (signInResult, error) in
            
            if let error = error
            {
                if let error = error as? AWSMobileClientError
                {
                    self.stopLoading()
                    DispatchQueue.main.async {
                        switch(error)
                        {
                        case .userNotConfirmed(message: _):
                            self.moveToRegisterOTPScreen()
                            
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
                            DispatchQueue.main.async
                                {
                                    self.showValidationMessage(withMessage: error.localizedDescription)
                            }
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
                        self.getAWSCognitoUser()
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
    
    func getAWSCognitoUser()
    {
        //Get AWS cognito User
        AWSMobileClient.default().getUserAttributes { (user ,error) in
            debugPrint(user)
            
            let jsonData = (try? JSONSerialization.data(withJSONObject: user))!
            let driverData = try? JSONDecoder().decode(DriverData.self, from: jsonData)
            print(driverData)
            
            //Get User Token
            DispatchQueue.main.async {
                if let driverDataObj = driverData
                {
                    self.getAWSTokenForInstaVoltLogin(driverDataObj: driverDataObj)
                }
            }
        }
    }
    
    func getAWSTokenForInstaVoltLogin(driverDataObj:DriverData)
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
            
            //store password to keychain
            if let password = self.txtPassword.text
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
            
            self.driverDetailAPICall()
        }
    }
    
    private func awsFacebookSignUpAPICall(isFaceBook:Bool)
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
 
                let claims = tokens.idToken?.claims
                
                if let email = claims?["email"] as? String, let userName = claims?["name"] as? String, let sub = claims?["sub"] as? String
                {
                    let fullNameArr = userName.components(separatedBy: " ")
                    
                        //Sign up for social login
                        self.signUpAPICall(firstName: fullNameArr[0], lastName: fullNameArr[1], email: email, referralCode: "", providerKey: sub, loginType: loginType)
                }
            }
        }
    }
    
    //MARK :- Driver details API Call(our backend API to get driver details)
    func driverDetailAPICall()
    {
        let parameters: [String: Any] = [
            Key.deviceId     : Device.uniqueIdentifier, // Unique device id
            Key.deviceName   : Device.deviceName,
//            Key.ipAddress    : Device.getIPAddress(),
            Key.platformType : "iOS"
        ]
        
        debugPrint(parameters)
        
        //Call driver detail API
        DriverController.shared.getDriverDetails(parameters: parameters, successCompletion: { (driverResponse) in
            self.stopLoading()
            self.driverDetails = driverResponse
            
            if let driverData = self.driverDetails?.data
            {
                DriverManager.set(driver: driverData)
                userDetail = driverData
                //user details store to user default
                if driverData.status?.code?.stringValue == "CANCELLED"
                {
                    self.showValidationMessage(withMessage: "Your account cancellation is in process so you will not be able to perform any action.",withActions: {
                        UserDefaults.standard.removeObject(forKey: "driverOtherDataDefault")
                        UserDefaults.standard.removeObject(forKey: "driverDefault")
                        KeyChainManager.shared.clearAccessToken()
                        
                        APIManager.API.removeAuthorizeToken()
                        AWSMobileClient.default().signOut()
                    })
                }
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
                            let userType:UserType = .driver
                            UserDefault[Key.userType] = userType.rawValue
                            IVApplication.shared.moveToProfileScreen()
                    }
                }
                print(driverData.first_name?.stringValue ?? "")
                self.stopLoading()
            }
        }) { (error, resError) in
            self.showAPIerror(error: error, resError: resError) {
                //                self.driverDetailAPICall()
                self.showValidationMessage(withMessage: error.errorMessage)
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
    
    //MARK :- Sign Up API Call for Social login
    func signUpAPICall(firstName: String, lastName: String, email: String, referralCode: String, providerKey: String, loginType: Int)
    {
        let parameters = [
            Key.firstName     : firstName,
            Key.lastName      : lastName,
            Key.email         : email,
            Key.providerKey   : providerKey
        ]
        
        debugPrint(parameters)
        
        //Call Sign up API
        self.startLoading()
        DriverController.shared.signUp(parameters: parameters, successCompletion:
            { (signUpResponse) in
                
                self.stopLoading()
                
                
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
        })
        { (error, resError) in
            self.stopLoading()
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
            //            self.showAPIerror(error: error, resError: resError)
            //            {
            //remaining
            //Our sign up API call on retry button
            //                        if let firstName = self.txtFirstName.text, let lastName = self.txtLastName.text, let email = self.txtEmail.text, let referralCode = self.txtReferralCode.text, let providerKey = self.driverDataForSignUp?.sub?.stringValue
            //                        {
            //                            self.signUpAPICall(firstName: firstName,
            //                                               lastName: lastName,
            //                                               email: email,
            //                                               referralCode: referralCode,
            //                                               providerKey: providerKey,
            //                                               isAWSCall: true)
            //                        }
            //            }
        }
    }
        
        
        //temp code starts
        //        let jsonData = (try? JSONSerialization.data(withJSONObject: SignUpJSON.signUpJSON))!
        //        tempsignUpResponse = try? JSONDecoder().decode(SignUpResponse.self, from: jsonData)
        //
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
        //        //store login type to user default
        //        let loginType : LoginType = .social
        //        print(loginType.rawValue)
        //        UserDefault[Key.loginType] = loginType.rawValue
        //
        //        //API call for Driver details
        //        self.driverDetailAPICall()
        //        //temp code ends
    }
}

//MARK:- TextField Delegates -
extension LoginViewController : UITextFieldDelegate
{
    func textField(_ textField : UITextField, shouldChangeCharactersIn range : NSRange, replacementString string : String) -> Bool
    {
        if  textField == txtEmail
        {
            if let email = textField.text, let textRange = Range(range, in: email)
            {
                let updatedText = email.replacingCharacters(in : textRange, with : string)
                print(updatedText)
                if updatedText.isValidEmail
                {
                    self.userNameValidationButton.isSelected = true
                }
                else
                {
                    self.userNameValidationButton.isSelected = false
                }
                return !(updatedText.count > 50)
            }
            else
            {
                return false
            }
        }
        else
        {
            if let password = textField.text, let textRange = Range(range, in: password)
            {
                let updatedText = password.replacingCharacters(in : textRange, with : string)
                return !(updatedText.count > 20)
            }
            else
            {
                return false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            self.view.endEditing(true)
        }
        return true
    }
}

//MARK:- Navigation Methods -
extension LoginViewController
{
    func moveToRegisterScreen()
    {
        if let registerScreen = R.storyboard.login.registerViewController()
        {
            navigationController?.pushViewController(registerScreen, animated: true)
        }
    }
    
    func moveToForgotPasswordScreen()
    {
        if let forgotPasswordScreen = R.storyboard.forgetPassword.forgotPasswordViewController()
        {
            navigationController?.pushViewController(forgotPasswordScreen, animated: true)
        }
    }
    
    func moveToHomeScreen()
    {
        let mainViewController = MainSideBarViewController()
        let mapViewController = R.storyboard.main().getNavigationController(identifire: String.Identifier.mainNavigationController)
        mainViewController.rootViewController = mapViewController
        if mainViewController.leftViewController?.isKind(of: SideMenuBarViewController.self) ?? false
        {
            let sideBar = mainViewController.leftViewController as! SideMenuBarViewController
            sideBar.selectedItem = .findStation
            sideBar.tableViewMenuItems.reloadData()
        }
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
//    func moveToProfileScreen()
//    {
//        let mainViewController = MainSideBarViewController()
//        let profileViewController = R.storyboard.main().getNavigationController(identifire: String.Identifier.profileNavigationController)
//        mainViewController.rootViewController = profileViewController
//        if mainViewController.leftViewController?.isKind(of: SideMenuBarViewController.self) ?? false
//        {
//            let sideBar = mainViewController.leftViewController as! SideMenuBarViewController
//            sideBar.selectedItem = .profile
//            sideBar.tableViewMenuItems.reloadData()
//        }
//        for viewController in profileViewController.viewControllers
//        {
//            if viewController.isKind(of: ProfileViewController.self)
//            {
//                let profileScreen = viewController as! ProfileViewController
//                profileScreen.shouldHideCancelButton = true
//                profileScreen.shouldHideCancelAccount = true
//                profileScreen.shouldHideForgotPassword = true
//                profileScreen.isFromLogin = true
//            }
//        }
//        navigationController?.pushViewController(mainViewController, animated: true)
//    }
    
    func moveToRegisterOTPScreen()
    {
        if let registerOTPScreen = R.storyboard.login.registerOTPViewController()
        {
            registerOTPScreen.isOPTVerifiedFromLoginScreen = false
            registerOTPScreen.password = txtPassword.text
            registerOTPScreen.email = txtEmail.text
            registerOTPScreen.isFromLoginScreen = true
            navigationController?.pushViewController(registerOTPScreen, animated: true)
        }
    }
}
