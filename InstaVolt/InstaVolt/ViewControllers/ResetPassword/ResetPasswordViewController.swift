//
//  ResetPasswordViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 29/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import TextFieldEffects
import AWSMobileClient

class ResetPasswordViewController: BaseViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var txtCode: HoshiTextField!
    @IBOutlet weak var txtReTypePassword: HoshiTextField!
    @IBOutlet weak var txtNewPassword: HoshiTextField!
    
    //MARK:- Variables -
    var email = ""
    var emailPreString = "To reset password, please enter the code we sent to "
    
    //MARK:- Life cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareResetPasswordView()
    }
    
    //MARK:- View Methods -
    private func prepareResetPasswordView() {
        let firstAttributedString = NSMutableAttributedString(string: emailPreString)
        let attributedFormat = [ NSAttributedString.Key.foregroundColor: UIColor(red: 0.717, green: 0.196, blue: 0.177, alpha: 1.0)]
        firstAttributedString.append(NSAttributedString(string: email, attributes: attributedFormat))
        labelEmail.attributedText = firstAttributedString
    }
    
    //MARK:- Webservice Methods -
    
    //MARK:- Action Methods -
    @IBAction func btnResetPassword(_ sender: UIButton) {
        if validateResetPassword()
        {
            self.callAWSConfirmPassword()
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Custom Methods -
    private func validateResetPassword() -> Bool
    {
        if txtCode.text?.trim().count == 0
        {
            showValidationMessage(withMessage: String.Title.emptyCode,withActions: {
                self.txtCode.becomeFirstResponder()
            })
            return false
        }
        else if txtNewPassword.text?.trim().count == 0
        {
            showValidationMessage(withMessage: String.Title.emptyNewPassword,withActions: {
                self.txtNewPassword.becomeFirstResponder()
            })
            return false
        }
        else if txtReTypePassword.text?.trim().count == 0 {
            showValidationMessage(withMessage: String.Title.emptyReTypePassword,withActions: {
                self.txtReTypePassword.becomeFirstResponder()
            })
            return false
        }
        else if txtReTypePassword.text != txtNewPassword.text {
            showValidationMessage(withMessage: String.Title.invalidReTypePassword,withActions: {
                self.txtReTypePassword.becomeFirstResponder()
            })
            return false
        }
        return true
    }
    
    private func callAWSConfirmPassword()
    {
        self.view.endEditing(true)
        self.startLoading()
        AWSMobileClient.default().confirmForgotPassword(username: email, newPassword: txtNewPassword.text!, confirmationCode: txtCode.text!) { (forgotPasswordResult, error) in
            if let errorMessage = error as? AWSMobileClientError
            {
                self.stopLoading()
                DispatchQueue.main.async {
                    switch errorMessage {
                    case .codeMismatch(message: _):
                        self.showValidationMessage(withMessage: String.Title.invalidCode)
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
                    case .userNotConfirmed(message: let message):
                        self.showValidationMessage(withMessage: message)
                    case .userNotFound(message: let message):
                        self.showValidationMessage(withMessage: message)
                    case .invalidPassword(message: let message):
                        self.showValidationMessage(withMessage: message)
                    default:
                        self.showValidationMessage(withMessage: String.Title.errorMessage)
                    }
                }
            }
            else if let forgotPasswordResult = forgotPasswordResult
            {
                print(forgotPasswordResult)
                DispatchQueue.main.async {
                    self.callNotifyEmail()
                }
            }
        }
    }
    
    private func callNotifyEmail()
    {
        let parameter: [String: Any] = [
            Key.email : email
        ]
        DriverController.shared.notifyPasswordChanged(parameters: parameter, successCompletion: { (successMessage) in
            self.stopLoading()
            self.showValidationMessage(withMessage: successMessage.message?.stringValue,withActions: {
                self.moveToLogin()
            })
        }) { (error, errorResponse) in
            self.stopLoading()
            self.showValidationMessage(withMessage: error.errorMessage)
        }
//        self.stopLoading()
//        let jsonData = (try? JSONSerialization.data(withJSONObject: JSONObjectDriver.changePasswordData))!
//        let resetPassword = try? JSONDecoder().decode(SuccessMessage.self, from: jsonData)
//        self.showValidationMessage(withMessage: resetPassword?.message?.stringValue,withActions: {
//            self.moveToLogin()
//        })
//        print(resetPassword as Any)
    }
    
}
//MARK:- UITextField Delegates -
extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtCode
        {
            txtNewPassword.becomeFirstResponder()
        }
        else if textField == txtNewPassword
        {
            txtReTypePassword.becomeFirstResponder()
        }
        else if textField == txtReTypePassword
        {
            self.view.endEditing(true)
        }
        return true
    }
}

//MARK:- Navigation Methods -
extension ResetPasswordViewController
{
    private func moveToLogin()
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
            if let loginScreen = R.storyboard.login.loginViewController()
            {
                self.navigationController?.pushViewController(loginScreen, animated: true)
            }
        }
    }
}
