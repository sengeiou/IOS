//
//  MSTextField.swift
//  VedantaComms
//
//  Created by Anshul on 19/11/19.
//  Copyright © 2019 MAC240. All rights reserved.
//

import UIKit
import Rswift
import SkyFloatingLabelTextField

struct PickerElement{
    var id: String
    var value: String
    var object: Any?
    var childs: [PickerElement] = []
    init(id: String, value: String, object: Any? = nil) {
        self.id = id
        self.value = value
        self.childs = []
        self.object = object
    }
}

enum TextFieldType{
    case email,name
}

class MSTextField: ViewFromXIB {
    
    @IBOutlet weak var tf: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPassword: PasswordTextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var vw: UIView!
    
    var isPicker        : Bool = false
    var isCardNumber    : Bool = false
    var isExpireDate    : Bool = false
    var isCVVNo         : Bool = false
    var picker          : UIPickerView?
    var datePicker      : UIDatePicker?
    var selectedDate    : Date? {
        didSet{
            guard let selectedDate = selectedDate else {
                self.text = ""
                return
            }
            self.text = DateApp.string(fromDate: selectedDate, withFormat: .birthDate)
        }
    }
    var selectedElement : PickerElement? {
        didSet{
            self.tf.text = selectedElement?.value ?? ""
            if self.childTF != nil{
                childTF?.selectedElement = nil
                childTF?.tf.text = nil
                childTF?.setupPicker(elements: self.selectedElement?.childs ?? [])
                childTF?.picker?.reloadComponent(0)
            }
            self.errorMessage = nil
        }
    }
    var pickerElements: [PickerElement] = []
    var childTF: MSTextField?
    var text: String{
        get{
            if isPassword{
                return tfPassword.text ?? ""
            }
            return tf.text ?? ""
        }set{
            if isPassword{
                self.tfPassword.text = newValue
            }else{
                self.tf.text = newValue
            }
        }
    }
    
    var isEmpty: Bool{
        if isPassword{
            return self.tfPassword.text ?? "" == ""
        }else{
            let string = (self.tf.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            return string == ""
        }
    }
    
    var textDidChanged: ((_ text: String) -> Void)?
    var dateDidChanged : ((_ date: Date) -> Void)?
    var didEndSelectingPickerElement: ((_ pickerElement: PickerElement?) -> Void)?
    var maximumCharacters: Int? = nil
    
    
    
    override func resignFirstResponder() -> Bool {
        return tf.resignFirstResponder() || tfPassword.resignFirstResponder()
    }
    
    var errorMessage: String? {
        didSet{
            self.lblError.text = self.errorMessage ?? ""
            self.lblError.numberOfLines = 0
            if self.errorMessage ?? "" != ""{
                self.shake()
                let lblHeight = (lblError.countLabelLines()) * 10
                self.updateHeightConstrait(height: CGFloat(50 + lblHeight + 3))
            }else{
                self.updateHeightConstrait(height: 50)
            }
        }
    }
    
    func setUpSkyFloatingLabelTextField() {
        tf.lineHeight           = 1
        tf.lineColor            = .lightGray
        tf.selectedLineColor    = UIColor(red: 0.710, green: 0.2, blue: 0.118, alpha: 1.0)
        tf.selectedLineHeight   = 1
        tf.selectedTitleColor   = UIColor(red: 0.710, green: 0.2, blue: 0.118, alpha: 1.0)
        
        tfPassword.lineHeight           = 1
        tfPassword.lineColor            = .lightGray
        tfPassword.selectedLineColor    = UIColor(red: 0.710, green: 0.2, blue: 0.118, alpha: 1.0)
        tfPassword.selectedLineHeight   = 1
        tfPassword.selectedTitleColor   = UIColor(red: 0.710, green: 0.2, blue: 0.118, alpha: 1.0)
        
        self.errorMessage = nil
        self.lblError.textColor = UIColor(red: 0.243, green: 0.243, blue: 0.243, alpha: 1.0)
    }
    
    @IBInspectable var placeholder : String = "" {
        didSet {
            setUpSkyFloatingLabelTextField()
            
            tf.placeholder = placeholder
            tf.selectedTitle = placeholder
            tfPassword.placeholder = placeholder
            tfPassword.selectedTitle = placeholder
            
            if (self.superview?.viewWithTag(self.tag + 1) as? MSTextField) != nil{
                tf.returnKeyType = .next
                tfPassword.returnKeyType = .next
            }
        }
    }
    
    @IBInspectable var isPassword : Bool = false {
        didSet {
            if isPassword {
                tf.isHidden = true
                tfPassword.delegate = self
                tfPassword.minimumFontSize = 12
                tfPassword.isSecureTextEntry = true
                tfPassword.font = R.font.sfProDisplayRegular(size: 12)
                tfPassword.preferredFont = R.font.sfProDisplayRegular(size: 20)
            } else {
                tf.delegate = self
                tf.minimumFontSize = 12
                tfPassword.isHidden = true
                tf.font = R.font.sfProDisplayRegular(size: 16)
            }
        }
    }
    
    @IBInspectable var isFullName : Bool = false {
        didSet {
            if isFullName {
                tf.textContentType = .name
                tf.autocapitalizationType = .words
            }
        }
    }
    
    @IBInspectable var isFirstName : Bool = false {
        didSet {
            if isFirstName {
                tf.textContentType = .givenName
                tf.autocapitalizationType = .words
            }
        }
    }
    
    @IBInspectable var isLastName : Bool = false {
        didSet {
            if isLastName {
                tf.textContentType = .familyName
                tf.autocapitalizationType = .words
            }
        }
    }
    
    @IBInspectable var isEmailAddress : Bool = false {
        didSet {
            if isEmailAddress {
                tf.textContentType = .emailAddress
                tf.keyboardType = .emailAddress
            }
        }
    }
    
    @IBInspectable var isPhoneNumber : Bool = false {
        didSet {
            if isPhoneNumber {
                tf.textContentType = .telephoneNumber
                tf.keyboardType = .numberPad
            }
        }
    }
    
    @IBInspectable var maxLength : Int = 100 {
        didSet {
            tf.maxLength = maxLength
            tfPassword.maxLength = maxLength
        }
    }
    
    @IBInspectable var isNextReturnType : Bool = false {
        didSet {
            if isNextReturnType {
                tf.returnKeyType = .next
                tfPassword.returnKeyType = .next
            } else {
                tf.returnKeyType = .done
                tfPassword.returnKeyType = .done
            }
        }
    }
    
    var returnKeyType : UIReturnKeyType = .next {
        didSet {
            tf.returnKeyType = returnKeyType
            tfPassword.returnKeyType = returnKeyType
        }
    }
    
    var keyboardType : UIKeyboardType = .default {
        didSet {
            tf.keyboardType = keyboardType
            tfPassword.keyboardType = keyboardType
            
            if keyboardType == .emailAddress {
                self.tf.textContentType = .emailAddress
            }
        }
    }
    
    private func setChangePasswordTextField(isCVVTF : Bool) {
        if isCVVTF == false {
            rightViewPasswordShowButtonAdd(textField: tfPassword)
        } else {
            tfPassword.rightView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            tfPassword.rightViewMode = .always
        }
        tfPassword.layer.masksToBounds = true
    }
    
    private func setCardTextField() {
        tf.textColor = UIColor(red: 0.7098, green: 0.2, blue: 0.118, alpha: 1.0)
        tf.tintColor = UIColor(red: 0.7098, green: 0.2, blue: 0.118, alpha: 1.0)
        tf.placeholderColor = UIColor(red: 0.243, green: 0.243, blue: 0.243, alpha: 1.0)
        tf.layer.masksToBounds = true
    }
    
    private func leftPaddingAdd(textField : UITextField) {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.size.height))
        textField.leftView = view
        textField.leftViewMode = .always
    }
    
    private func rightPaddingAdd(textField : UITextField) {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.size.height))
        textField.rightView = view
        textField.rightViewMode = .always
    }
    
    private func leftImageAdd(textField : UITextField, image : UIImage) {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height, height: textField.frame.size.height))
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height, height: textField.frame.size.height))
        imageView.image = image
        imageView.contentMode = .center
        view.addSubview(imageView)
        textField.leftView = view
        textField.leftViewMode = .always
    }
    
    private func rightImageAdd(textField : UITextField, image : UIImage) {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height, height: textField.frame.size.height))
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height, height: textField.frame.size.height))
        imageView.image = image
        imageView.contentMode = .center
        view.addSubview(imageView)
        textField.rightView = view
        textField.rightViewMode = .always
    }
    
    private func rightViewPasswordShowButtonAdd(textField : UITextField) {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height, height: textField.frame.size.height))
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height, height: textField.frame.size.height))
        button.setImage(R.image.eye(), for: .normal)
        button.setImage(R.image.eyeSelected(), for: .selected)
        button.addTarget(self, action: #selector(didTapOnButtonShowPassword(_:)), for: .touchUpInside)
        view.addSubview(button)
        textField.rightView = view
        textField.rightViewMode = .always
    }
    
    @objc private func didTapOnButtonShowPassword(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
    }
    
    func setupPicker(elements: [PickerElement]){
        self.isPicker = true
        self.pickerElements = elements
        let pickerVw = UIPickerView()
        pickerVw.dataSource = self
        pickerVw.delegate = self
        self.tf.inputView = pickerVw
        self.rightImageAdd(textField: tf, image: UIImage())
    }
    
    @objc func onClickPicker(){
        _ = self.becomeFirstResponder()
    }
    
    func setupDatePicker(isTime: Bool = false){
        self.datePicker = UIDatePicker()
        if isTime{
            datePicker?.datePickerMode = .time
            datePicker?.addTarget(self, action: #selector(datePickerTimeChanged(picker:)), for: .valueChanged)
        }else{
            datePicker?.datePickerMode = .date
            datePicker?.maximumDate = Date()
            datePicker?.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        }
        self.tf.inputView = datePicker
        
        let view =  UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tf.frame.size.height, height: self.tf.frame.size.height))
        let button = UIButton.init(frame: view.bounds)
        button.setImage(UIImage(), for: .normal)
        button.addTarget(self, action: #selector(self.onClickPicker), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func datePickerTimeChanged(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        self.text = formatter.string(from: picker.date)
    }
    
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        self.selectedDate = picker.date
        self.dateDidChanged?(picker.date)
    }
    
    
    func updateHeightConstrait(height: CGFloat){
        if let constraint = (self.constraints.filter{$0.firstAttribute == .height}.first) {
            if constraint.constant == height{
            }else{
                constraint.constant = height
                self.layoutIfNeeded()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        if isPassword{
            return tfPassword.becomeFirstResponder()
        }else{
            return tf.becomeFirstResponder()
        }
    }
    
    func validateWhitelistCharactor() -> Bool {
//        if self.errorMessage ?? "" == "" || self.errorMessage == MText.Alert.validation_blacklist_genral{
            if !self.text.isWhitelist(){
                self.errorMessage = "" //MText.Alert.validation_blacklist_genral
                return false
            }
//        }
        return true
    }
}

extension MSTextField: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isPicker{
            if self.selectedElement == nil{
                self.selectedElement = self.pickerElements.first
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isPicker{
            self.didEndSelectingPickerElement?(self.selectedElement)
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = textField.text as NSString?
        let newString = nsString!.replacingCharacters(in: range, with: string)
        let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn:"0123456789").inverted) == nil
        
        self.errorMessage = nil
//        if isName{
//            let allowedCharacter = CharacterSet.letters
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacter.isSuperset(of: characterSet)
//        }
        if maximumCharacters != nil{
            if textField.text?.count ?? 0 > maximumCharacters!{
                return false
            }
        }
        if isCardNumber {
            if !replacementStringIsLegal {return false}
            if textField.text!.count <= 18 {
                textField.text = newString.creditDebitCardNumberFormatted
            } else if string == "" {return true}
            return false
        }
//        if isFullName {
//            let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted) == nil
//            if !replacementStringIsLegal {
//                return false
//            }
//            return true
//        }
        if isExpireDate {
            if !replacementStringIsLegal {return false}
            if textField.text!.count <= 6 {
                textField.text = newString.creditDebitCardExpireyTimeFormatted
            } else if string == "" {return true}
            return false
        }
        if isCVVNo {
            if newString.count > 3{
                textField.text = "\(newString.prefix(3))"
                return false
            }
        }
        if isPhoneNumber {
            let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn:"0123456789").inverted) == nil
            if !replacementStringIsLegal {
                return false
            }
            return true
        }
        textDidChanged?(newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let view = self.superview?.viewWithTag(self.tag + 1) as? MSTextField{
            _ = view.becomeFirstResponder()
        }
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension MSTextField: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerElements.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerElements[row].value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !(row < self.pickerElements.count) {return}
        self.selectedElement = self.pickerElements[row]
        self.errorMessage = nil
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        label.lineBreakMode = .byWordWrapping
        label.text = self.pickerElements[row].value
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
}
