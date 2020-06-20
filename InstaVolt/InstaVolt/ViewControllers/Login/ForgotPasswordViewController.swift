//
//  ForgotPasswordViewController.swift
//  InstaVolt
//
//  Created by PCQ111 on 19/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import TextFieldEffects
import AWSMobileClient

class ForgotPasswordViewController: BaseViewController
{
    //MARK:- Outlets -
    @IBOutlet weak var txtEmailAddress: HoshiTextField!
    
    //MARK:- Variables -
    private var userNameValidationButton : UIButton = {
        let buttonTick = UIButton(frame : CGRect(x : 0, y : 0, width : 40, height : 40))
        buttonTick.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
        buttonTick.isUserInteractionEnabled = false
        buttonTick.setImage(#imageLiteral(resourceName: "email_verified"), for : .selected)
        return buttonTick
    }()
    
    
    //MARK:- Life Cycle Methods -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        prepareForgotPasswordView()
    }
    
    //MARK:- View Methods -
    private func prepareForgotPasswordView()
    {
        setUpEmailTextfield(userNameTextField: txtEmailAddress)
    }
    
    //MARK:- Webservice Methods -
    
    //MARK:- Action Methods -
    @IBAction func resetPassword(_ sender: UIButton)
    {
        if validForgotPassword() {
            self.callAwsForgotPasswordMethod()
        }
    }
    
    @IBAction func backButton(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Objective Methods -
    
    //MARK:- Custom Methods -
    private func callAwsForgotPasswordMethod()
    {
        self.startLoading()
        AWSMobileClient.default().forgotPassword(username: txtEmailAddress.text!) { (forgotPasswordResult, error) in
            self.stopLoading()
            if let forgotPasswordResult = forgotPasswordResult
            {
                switch(forgotPasswordResult.forgotPasswordState)
                {
                case .confirmationCodeSent:
                    print("Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)")
                    
                    DispatchQueue.main.async {
                        self.showValidationMessage(withMessage: "Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)",withActions: {
                                    self.moveToResetPassword()
                        })
                    }
                default:
                    print("Error: Invalid case.")
                }
            }
            else if let error = error
            {
                if let errorMessage = error as? AWSMobileClientError
                {
                    DispatchQueue.main.async {
                        switch errorMessage {
                        case .codeDeliveryFailure(message: let message):
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
                        default:
                            self.showValidationMessage(withMessage: String.Title.errorMessage)
                        }
                    }
                }
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    private func setUpEmailTextfield(userNameTextField : HoshiTextField)
    {
        let container = UIView(frame : userNameValidationButton.frame)
        container.backgroundColor = .clear
        container.addSubview(userNameValidationButton)
        
        userNameTextField.rightViewMode = .always
        userNameTextField.rightView = container
    }
    
    private func validForgotPassword() -> Bool
    {
        if txtEmailAddress.text?.trim().count == 0
        {
            self.showValidationMessage(withMessage: String.Title.emptyEmail,withActions: {
                self.txtEmailAddress.becomeFirstResponder()
            })
            return false
        }
        else if txtEmailAddress.text?.isValidEmail == false {
            self.showValidationMessage(withMessage: String.Title.validEmail,withActions: {
                self.txtEmailAddress.becomeFirstResponder()
            })
            return false
        }
        return true
    }
}

//MARK:- UITextField Delegate Methods -
extension ForgotPasswordViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtEmailAddress
        {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if  textField == txtEmailAddress
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
        return true
    }
}

//MARK:- Navigation Methods -
extension ForgotPasswordViewController
{
    func moveToResetPassword()
    {
        if let resetPasswordScreen = R.storyboard.forgetPassword.resetPasswordViewController()
        {
            resetPasswordScreen.email = txtEmailAddress.text!
            navigationController?.pushViewController(resetPasswordScreen, animated: true)
        }
    }
}
