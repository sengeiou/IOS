//
//  ProfileViewController.swift
//  InstaVolt
//
//  Created by PCQ111 on 19/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import TextFieldEffects
import AWSMobileClient

class ProfileViewController: BaseViewController
{
    //Mark:- Outlets -
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var txtFirstName: HoshiTextField!
    @IBOutlet weak var txtLastName: HoshiTextField!
    @IBOutlet weak var txtEmail: HoshiTextField!
    @IBOutlet weak var txtAddress: HoshiTextField!
    @IBOutlet weak var txtBillingAddress: HoshiTextField!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var viewCancelAccount: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var changePasswordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonHeightCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelAccountHeightCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButtonTopCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBillingAddress: UIButton!
    @IBOutlet weak var buttonAddress: UIButton!
    @IBOutlet weak var sameAsAddressButton: UIButton!
    
    //MARK:- Variables -
    var driverData: DriverResponse?
    var shouldHideForgotPassword: Bool = false
    var shouldHideCancelAccount: Bool = false
    var shouldHideCancelButton: Bool = false
    var isFromLogin: Bool = false
    var isFromSignUp: Bool = false
    
    private var searchAddressButton : UIButton = {
        let addressSearch = UIButton(frame : CGRect(x : 10, y : 15, width : 40, height : 40))
        addressSearch.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addressSearch.setImage(R.image.search_black(), for : .normal)
        addressSearch.imageView?.contentMode = .right
        addressSearch.addTarget(self, action : #selector(addressButton(_:)), for : .touchUpInside)
        return addressSearch
    }()
    
    private var searchBillingAddress : UIButton = {
        let addressSearch = UIButton(frame : CGRect(x : 10, y : 15, width : 40, height :  40))
           addressSearch.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
           addressSearch.setImage(R.image.search_black(), for : .normal)
            addressSearch.imageView?.contentMode = .right
           addressSearch.addTarget(self, action : #selector(billingAdressButton(_:)), for : .touchUpInside)
           return addressSearch
       }()
    
    //MARK:- Life Cycle Methods -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        prepareProfileView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareAddressTextField()
    }
    
    //MARK:- View Methods -
    private func prepareProfileView()
    {
        let userType = UserDefault[Key.loginType] as? Int
        if  userType == 2 || userType == 3
        {
            viewChangePassword.isHidden = true
            changePasswordHeightConstraint.constant = 0.0
        }
        if shouldHideForgotPassword
        {
            viewChangePassword.isHidden = true
            changePasswordHeightConstraint.constant = 0.0
            saveButtonTopCOnstraint.constant = 0.0
        }
        if shouldHideCancelAccount
        {
            viewCancelAccount.isHidden = true
            cancelAccountHeightCOnstraint.constant = 0.0
        }
        if shouldHideCancelButton
        {
            buttonCancel.isHidden = true
            cancelButtonHeightCOnstraint.constant = 0.0
        }
        if driverData == nil
        {
//            self.retriveDriverData()
            callGetDriverDetail()
        }
        else
        {
            self.setDriverData()
        }
    }
    
    func prepareAddressTextField()
    {
        if txtAddress.text == ""
        {
            buttonAddress.isEnabled = true
        }
        else
        {
            buttonAddress.isEnabled = false
            setUpAddressField()
        }
        if txtBillingAddress.text == ""
        {
            buttonBillingAddress.isEnabled = true
        }
        else
        {
            buttonBillingAddress.isEnabled = false
            setUpBillingAddress()
        }
    }
    
    //MARK:- Webservice Methods -
//    private func retriveDriverData()
//    {
//        self.callGetDriverDetail()
//        let jsonData = (try? JSONSerialization.data(withJSONObject: JSONObjectDriver.DriverDetails))!
//        driverData = try? JSONDecoder().decode(DriverResponse.self, from: jsonData)
//        print(driverData as Any)
//        setDriverData()
//    }
    
    private func callGetDriverDetail()
    {
        let parameters: [String: Any] = [
                    Key.deviceId     : Device.uniqueIdentifier, // Unique device id
                    Key.deviceName   : Device.deviceName,
//                    Key.ipAddress    : Device.getIPAddress(),
                    Key.platformType : "iOS"
                ]
                
               // Call driver detail API
                self.startLoading()
                DriverController.shared.getDriverDetails(parameters: parameters, successCompletion: { (driverResponse) in
                    self.driverData = driverResponse
                    DriverManager.set(driver: self.driverData?.data)
                    self.setDriverData()
                    self.stopLoading()
                }) { (error, resError) in
                    self.showAPIerror(error: error, resError: resError) {
                        self.stopLoading()
                        self.callGetDriverDetail()
                        ///self.showValidationMessage(withMessage: error.errorMessage)
                    }
                }
    }
    
    private func updateDriverData()
    {
        self.startLoading()
        let parmater:[String: Any] = [
            Key.firstName       : txtFirstName.text!,
            Key.lastName        : txtLastName.text!,
            Key.address         : txtAddress.text!,
            Key.billingAddress  : txtBillingAddress.text!
        ]
        DriverController.shared.updateDriverDetail(parameters: parmater, successCompletion: { (updateDriver) in
             self.stopLoading()
            self.buttonSave.isUserInteractionEnabled = true
            self.showValidationMessage(withMessage: updateDriver.message?.stringValue,withActions: {
                if self.isFromLogin || self.isFromSignUp
                {
                    self.moveToHomeScreen()
                }
               self.callGetDriverDetail()
            })
        }) { (error, errorResponse) in
            self.stopLoading()
            self.showAlert(message: error.errorMessage ?? String.Title.errorMessage)
        }
//        let jsonData = (try? JSONSerialization.data(withJSONObject: JSONObjectDriver.updateDriverData))!
//        let updateDriver = try? JSONDecoder().decode(UpdateDriver.self, from: jsonData)
//        self.showValidationMessage(withMessage: updateDriver?.message?.stringValue,withActions: {
//            self.moveToHomeScreen()
//        })
    }
    
    private func cancelDriverAccount()
    {
                self.startLoading()
                DriverController.shared.cancelDriverAccount(successCompletion: { (cancelDriverResponse) in
                    self.stopLoading()
                    self.showValidationMessage(withMessage: cancelDriverResponse.message?.stringValue,withActions: {
                        UserDefaults.standard.removeObject(forKey: "driverOtherDataDefault")
                        UserDefaults.standard.removeObject(forKey: "driverDefault")
                        UserDefaults.standard.removeObject(forKey: Key.userType)
                        UserDefaults.standard.removeObject(forKey: Key.loginType)

                        KeyChainManager.shared.clearPassword()
                        KeyChainManager.shared.clearAccessToken()
                        APIManager.API.removeAuthorizeToken()
                        AWSMobileClient.default().signOut()
                        self.moveToLogin()
                    })
                }) { (error, errorResponse) in
                    self.stopLoading()
                    self.showAlert(message: error.errorMessage ?? String.Title.errorMessage)
                }
        
//        let jsonData = (try? JSONSerialization.data(withJSONObject: JSONObjectDriver.cancelDriverAccount))!
//        let cancelDriver = try? JSONDecoder().decode(SuccessMessage.self, from: jsonData)
//        self.showValidationMessage(withMessage: cancelDriver?.message?.stringValue ?? "",withActions: {
//            //Remaining Delete Keychain wrapper
//
//        })
    }
    
    //MARK:- Action Methods
    @IBAction func changePassword(_ sender: UIButton)
    {
        moveToChangePassword()
    }
    
    @IBAction func cancelAccount(_ sender: UIButton) {
        let confirmCancelAction = UIAlertAction(title: String.Title.yes, style: .default) { (alert) in
            self.cancelDriverAccount()
        }
        let declineCancelAction = UIAlertAction(title: String.Title.no, style: .cancel) { (alert) in
            print("No pressed")
        }
        self.showAlert(message: String.Title.cancelAccountString,actions: [confirmCancelAction,declineCancelAction])
    }
    
    @IBAction func save(_ sender: UIButton)
    {
        //check validations and move to map screen
        if validateDriverProfile()
        {
            self.updateDriverData()
        }
    }
    
    @IBAction func menuIcon(_ sender: UIButton)
    {
        let sideBar = self.sideMenuController as! MainSideBarViewController
        sideBar.showLeftViewAnimated()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addressButton(_ sender: UIButton)
    {
        moveToAddressSuggestion(isFromBilling: false)
    }
    
    @IBAction func billingAdressButton(_ sender: UIButton)
    {
        moveToAddressSuggestion(isFromBilling: true)
    }
    
    @IBAction func useSameAsAddress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            txtBillingAddress.text = txtAddress.text
        }
        else
        {
            txtBillingAddress.text = ""
        }
    }
    //MARK:- Custom Method -
    private func setDriverData()
    {
        txtFirstName.text = driverData?.data?.first_name?.stringValue
        txtLastName.text = driverData?.data?.last_name?.stringValue
        txtEmail.text = driverData?.data?.email?.stringValue
        txtAddress.text = driverData?.data?.address?.stringValue
        txtBillingAddress.text = driverData?.data?.billing_address?.stringValue
        prepareAddressTextField()
    }
    
    private func setUpAddressField()
    {
        let container = UIView(frame : searchAddressButton.frame)
        container.backgroundColor = .white
        container.addSubview(searchAddressButton)
        
        txtAddress.rightViewMode = .whileEditing
        txtAddress.rightView = container
    }
    
    private func setUpBillingAddress()
    {
        let container = UIView(frame : searchBillingAddress.frame)
        container.backgroundColor = .white
        container.addSubview(searchBillingAddress)
        
        txtBillingAddress.rightViewMode = .whileEditing
        txtBillingAddress.rightView = container
    }
    
    private func validateDriverProfile() -> Bool
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
        else if txtAddress.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyAddress,withActions: {
                self.txtAddress.becomeFirstResponder()
            })
            return false
        }
        else if txtBillingAddress.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyBillingAddress,withActions: {
                self.txtBillingAddress.becomeFirstResponder()
            })
            return false
        }
        return true
    }
}

//MARK:- Navigations Methods -
extension ProfileViewController
{
    private func moveToHomeScreen()
    {
        let mainViewController = MainSideBarViewController()
        let mapViewController = R.storyboard.main().getNavigationController(identifire: String.Identifier.mainNavigationController)
        mainViewController.rootViewController = mapViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
//        if let mapScreen = R.storyboard.main.mapViewController()
//        {
//            mapScreen.isSignedInDone = true
//            navigationController?.pushViewController(mapScreen, animated: true)
//        }
    }
    
    private func moveToChangePassword()
    {
        if let forgotPasswordVC = R.storyboard.profile.changePasswordViewController()
        {
            forgotPasswordVC.email = driverData?.data?.email?.stringValue ?? ""
            self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
        }
    }
    
    private func moveToLogin()
    {
        if let loginScreen = R.storyboard.login.loginViewController()
        {
            self.navigationController?.pushViewController(loginScreen, animated: true)
        }
    }
    
    private func moveToAddressSuggestion(isFromBilling: Bool)
    {
        if let addressSuggestion = R.storyboard.profile.addressSuggestionViewController()
        {
            addressSuggestion.isFromBillingAddress = isFromBilling
            addressSuggestion.getAddressDelegate = self
            self.navigationController?.pushViewController(addressSuggestion, animated: true)
        }
    }
}

//MARK:- UITextField Delegate Methods -
extension ProfileViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtFirstName
        {
            txtLastName.becomeFirstResponder()
        }
        else if textField == txtLastName
        {
            txtAddress.becomeFirstResponder()
        }
        else if textField == txtAddress
        {
            txtBillingAddress.becomeFirstResponder()
        }
        else if textField == txtBillingAddress
        {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == txtAddress
        {
            if sameAsAddressButton.isSelected
            {
                txtBillingAddress.text = txtAddress.text
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtAddress || textField == txtBillingAddress
        {
            if textField.text?.count == 0
            {
                if textField == txtAddress
                {
                    moveToAddressSuggestion(isFromBilling: false)
                }
                else
                {
                    moveToAddressSuggestion(isFromBilling: true)
                }
                return false
            }
        }
        return true
    }
}
//MARK:- Get Address Delegate -
extension ProfileViewController: GetAddress
{
    func getSelectedAddress(isFromBilling: Bool, address: String, postcode: String) {
        if isFromBilling
        {
            txtBillingAddress.text = address + " " + postcode
        }
        else
        {
            txtAddress.text = address + " " + postcode
        }
    }
}
