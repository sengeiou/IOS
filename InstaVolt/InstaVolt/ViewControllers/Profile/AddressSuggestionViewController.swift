//
//  AddressSuggestionViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

protocol GetAddress {
    func getSelectedAddress(isFromBilling: Bool,address: String,postcode: String)
}

class AddressSuggestionViewController: UIViewController {

    //MARK:- Outlets -
    @IBOutlet weak var txtPinCode: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var tableViewAdressSuggestion: UITableView!
    
    //MARK:- Variables -
    var addressSuggestion       : AddressSuggestion?
    var apiTimer                : Timer?
    var isFromBillingAddress    : Bool = false
    var getAddressDelegate      : GetAddress?
    
    //MARK:- Lifecycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareAddressSuggestionController()
    }
    
    //MARK:- View Methods -
    private func prepareAddressSuggestionController()
    {
        
    }
    
    //MARK:- Webservice Methods -
    private func callGetAddressAPI(postcode: String, address: String)
    {
        ProfileController.shared.getAddressListing(postcode: postcode, address: address, successCompletion: { (address) in
            self.addressSuggestion = address
            self.tableViewAdressSuggestion.reloadData()
            self.tableViewAdressSuggestion.isHidden = false
        }) { (error, ErrorResponse) in
            if ErrorResponse?.code?.intValue == 401
            {
                self.showValidationMessage(withMessage: String.Title.invalidAddress)
            }
            else if ErrorResponse?.code?.intValue == 400
            {
                self.showValidationMessage(withMessage: String.Title.invalidPostcode)
            }
            else
            {
                self.showValidationMessage(withMessage: ErrorResponse?.Message?.stringValue)
            }
        }
    }
    
    //MARK:- Action Methods -
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Custom Methods -
}
//MARK:- UITableView Delegate & DataSource -
extension AddressSuggestionViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressSuggestion?.addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addressCell = tableView.registerDeque(type: AddressSuggestionTableViewCell.self, indexPath: indexPath)
        addressCell.address = addressSuggestion?.addresses?[indexPath.row].stringValue
        return addressCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let address = addressSuggestion?.addresses?[indexPath.row].stringValue
        {
            let tempAddress = address.replacingOccurrences(of: ", , , , ,", with: ",").replacingOccurrences(of: ", , , ,", with: ",").replacingOccurrences(of: ", , ,", with: ",").replacingOccurrences(of: ", ,", with: ",")
            getAddressDelegate?.getSelectedAddress(isFromBilling: isFromBillingAddress, address: tempAddress, postcode: txtPinCode.text ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
}
//MARK:- UITextField Delegate -
extension AddressSuggestionViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPinCode
        {
            apiTimer?.invalidate()
            if textField.text?.count ?? 0 >= 5
            {
                txtAddress.isUserInteractionEnabled = true
            }
            else
            {
                txtAddress.isUserInteractionEnabled = false
            }
        }
        else if textField == txtAddress
        {
            apiTimer?.invalidate()
            apiTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (_) in
                self.callGetAddressAPI(postcode: self.txtPinCode.text ?? "", address: self.txtAddress.text ?? "")
            })
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPinCode
        {
            if textField.text?.count ?? 0 > 5
            {
                txtAddress.becomeFirstResponder()
            }
            self.callGetAddressAPI(postcode: txtPinCode.text ?? "", address: txtAddress.text ?? "")
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPinCode
        {
            self.callGetAddressAPI(postcode: txtPinCode.text ?? "", address: txtAddress.text ?? "")
        }
    }
}
