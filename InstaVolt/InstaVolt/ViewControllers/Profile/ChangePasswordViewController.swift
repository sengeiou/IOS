//
//  ChangePasswordViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 25/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import TextFieldEffects
import AWSMobileClient

class ChangePasswordViewController: BaseViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var txtOldPassword: HoshiTextField!
    @IBOutlet weak var txtNewPassword: HoshiTextField!
    @IBOutlet weak var txtReTypeNewPassword: HoshiTextField!
    
    //MARK:- Variables -
    var email: String = ""
    
    //MARK:- LifeCycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Webservice Methods -
    private func notifyChangePassword()
    {
        let parameter: [String: Any] = [
            Key.email   : email
        ]
        DriverController.shared.notifyPasswordChanged(parameters: parameter, successCompletion: { (successMessage) in
            self.stopLoading()
            self.showValidationMessage(withMessage: successMessage.message?.stringValue,withActions: {
                self.navigationController?.popViewController(animated: true)
            })
        }) { (error, errorResponse) in
            self.stopLoading()
            self.showAlert(message: error.errorMessage ?? String.Title.errorMessage)
        }
        
//        let jsonData = (try? JSONSerialization.data(withJSONObject: JSONObjectDriver.cancelDriverAccount))!
//        let cancelDriver = try? JSONDecoder().decode(DriverResponse.self, from: jsonData)
//        print(cancelDriver as Any)
//        self.stopLoading()
    }
    
    private func callAwsApi()
    {
        self.startLoading()
        AWSMobileClient.default().changePassword(currentPassword: txtOldPassword.text  ?? "", proposedPassword: txtNewPassword.text ?? "") { (error) in
            if let error = error as? AWSMobileClientError
            {
                self.stopLoading()
                DispatchQueue.main.async {
                    switch error {
                    case .notAuthorized(message: _):
                        self.showValidationMessage(withMessage: String.Title.incorrectPassword)
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
            else
            {
                DispatchQueue.main.async
                    {
                        //self.showValidationMessage(withMessage: String.Title.passwordChanged)
                        self.notifyChangePassword()
                }
            }
        }
    }
    
    //MARK:- Action Methods -
    @IBAction func changePassword(_ sender: UIButton) {
        if validateChangePassword()
        {
            //call API
            self.callAwsApi()
        }
    }
    
    @IBAction func backButton(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Custom Methods -
    private func validateChangePassword() -> Bool
    {
        if txtOldPassword.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyOldPassword,withActions: {
                self.txtOldPassword.becomeFirstResponder()
            })
            return false
        }
        else if txtNewPassword.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyNewPassword,withActions: {
                self.txtNewPassword.becomeFirstResponder()
            })
            return false
        }
        else if txtReTypeNewPassword.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyReTypePassword,withActions: {
                self.txtReTypeNewPassword.becomeFirstResponder()
            })
            return false
        }
        else if txtReTypeNewPassword.text != txtNewPassword.text
        {
            self.showValidationMessage(withMessage: String.Title.invalidReTypePassword,withActions: {
                self.txtReTypeNewPassword.becomeFirstResponder()
            })
            return false
        }
        return true
    }
}

//MARK:- UITextField Delegate Methods -
extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtOldPassword
        {
            txtNewPassword.becomeFirstResponder()
        }
        else if textField == txtNewPassword
        {
            txtReTypeNewPassword.becomeFirstResponder()
        }
        else if textField == txtReTypeNewPassword
        {
            self.view.endEditing(true)
        }
        return true
    }
}

