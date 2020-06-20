//
//  String+Extension.swift
//  InstaVolt
//
//  Created by PCQ111 on 15/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

extension String
{
    var isValidPassword: Bool
    {
        if self.count >= 8 && self.count <= 16
        {
            return true
        }
        return false
    }
    
    var isValidEmail : Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var isValidName: Bool {
        let nameRegEx = "[A-Za-z-]{1,15}"
        let namePred = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: self)
    }
    
    var isValidCvv: Bool
    {
        let cvvEx = "[0-9]{3,4}"
        let cvvPred = NSPredicate(format: "SELF MATCHES %@", cvvEx)
        return cvvPred.evaluate(with: self)
    }
    
    /// Returns length of string
    var length: Int
    {
        return self.count
    }
    
    /// Returns length of string after trim it
    var trimmedLength: Int
    {
        return self.trimmed.length
    }
    
    func isEqualToString(find: String) -> Bool
    {
        return String(format: self) == find
    }
    
    
    var isInt: Bool
    {
        return Int(self) != nil
    }
    
    var numberValue:NSNumber?
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
    
    func toBool() -> Bool?
    {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    
    var stringToDate : Date?
    {
        return DateFormatter.dateFormater.date(from: self)
    }
    
    var stringToDateWithMiliSecond : Date?
    {
        return DateFormatter.dateFormaterLongWithMiliSecond.date(from: self)
    }
    
    var trimmed : String
    {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var checkIfNil : String
    {
        return self == "" ? "N/A" : self
    }
    
    func safelyLimitedTo(length n: Int)->String {
        let c = self
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
    
     func isWhitelist() -> Bool{
        let arrBlackListStrings = ["--","*/","/*","<",">"]
        return !arrBlackListStrings.map({self.contains($0)}).contains(true)
    }
    
    var phoneFormatted: String {
        //"(###) ###-####"
        let input = self.normalFormatted
        var output = ""
        input.enumerated().forEach { index, c in
            if (index.isMultiple(of: 2) == false) {
                output = " "
            }
            output.append(c)
        }
        return output
    }
    
    var normalFormatted: String {
        return self.digits
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var aadharCardFormatted: String {
        //"0000 0000 0000"
        let input = self.normalFormatted
        var output = ""
        input.enumerated().forEach { index, c in
            if index == 4 {
                output = "\(output) "
            } else if index == 8 {
                output = "\(output) "
            }
            output.append(c)
        }
        return output
    }
    
    var creditDebitCardNumberFormatted: String {
        //"0000 0000 0000 0000"
        let input = self.normalFormatted
        var output = ""
        input.enumerated().forEach { index, c in
            if index == 4 {
                output = "\(output) "
            } else if index == 8 {
                output = "\(output) "
            } else if index == 12 {
                output = "\(output) "
            }
            output.append(c)
        }
        return output
    }
    
    var creditDebitCardExpireyTimeFormatted: String {
        //"MM / YYYY"
        let input = self.normalFormatted
        var output = ""
        input.enumerated().forEach { index, c in
            if index == 2 {
                output = "\(output)/"
            }
            output.append(c)
        }
        return output
    }
}

extension Optional where Wrapped == String
{
    var checkIfNil : String
    {
        if let self = self
        {
            return self.checkIfNil
        }
        else
        {
            return "N/A"
        }
    }
}


extension String
{
    //for Currency type validations................
    static private func doubleFormatter() -> NumberFormatter
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal;
        formatter.allowsFloats = true;
        return formatter
    }
    private var amountSeparator : String
    {
        return String.doubleFormatter().decimalSeparator ?? "."
    }
}


extension String
{
    func toDouble() -> Double?
    {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
