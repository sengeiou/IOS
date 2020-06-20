//
//  APIManager.swift
//  InstaVolt
//
//  Created by PCQ111 on 11/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import Alamofire


enum WebError: Error
{
    case badRequest //400
    
    case conflictError //409
    
    case forbidden //403
    
    case internalServerError //500
    
    case notFound //404
    
    case serviceUnavailable  //503
    
    case unauthorized //401
    
    /// Throws when request timeout occurs
    case timeout
    
    /// Throws when application cancel running request
    case cancel
    
    /// Throws when error is none of the above
    case unknown
    
    /// Thows when custom error founds
    case custom(String?)
    
    /// Throws when server don't give any response
    case noData
    
    /// Throws when internet isn't connected
    case noInternet
    
    /// Throws when server is down because of any reason
    case hostFail
    
    /// Throws when response is not as per predefined json format
    case parseFail
    
    
    static func getErrorByCode(_ statusCode: Int!, message : String) -> WebError
    {
        return .custom(message)
    }
    
    var errorMessage: String?
    {
        switch self
        {
        case .badRequest: //400
            return "Bad request"
        case .conflictError: //409
            return "ConflictError"
        case .forbidden: //403
            return "You do not have access to requested data."
        case .internalServerError: //500
            return "InternalServerError"
        case .notFound: //404
            return "NotFound"
        case .serviceUnavailable : //503
            return "ServiceUnavailable"
        case .unauthorized: //401
            return "You are not authorised."
        case .noData:
            return "No data found."
        case .noInternet:
            return "Network not reachable."
        case .hostFail:
            return "Failed to retrieve host."
        case .parseFail:
            return "Failed to parse data."
        case .timeout:
            return "Request timed out."
        case .cancel:
            return "Canceled request."
        case .unknown:
//            return "Coundn't process request at the moment, please try again later."
            return "There is an error processing your request, Please try again later."
        case .custom(let errorMessage) :
            return errorMessage
        }
    }
}

final class APIManager: SessionManager
{
    // MARK: - Custom header field -
    var header: HTTPHeaders = [
        "Content-Type"  : "application/json",
        "Authorization" : ""

    ]
    var multipartHeader: HTTPHeaders = [
        "Content-type": "multipart/form-data"
    ]
    var urlEncoded: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    
    var token : String = ""

    
    static let API: APIManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest = 60
        configuration.httpMaximumConnectionsPerHost = 20
        
        var apiManager = APIManager(configuration: configuration)
        return apiManager
    }()
    
    /// Set Bearer Token here
    ///
    /// - parameter token: string without bearer prefix for `token`
    func set(authorizeToken token: String!)
    {
        header[Key.authorization] = "Bearer " + token
    }
    
    
    /// Remove Bearer token with this method
    func removeAuthorizeToken()
    {
        header.removeValue(forKey: Key.authorization)
    }
    
    
    func cancelAllTasks()
    {
        self.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    func sendRequest<T: Codable>(_ route: Router, type: T.Type,  successCompletion: @escaping (_ response: T) -> Void, failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void)
    {
        guard Device.isReachable == true else {
            failureCompletion(WebError.noInternet, nil)
            return
        }
        
        let path = route.path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var parameter = route.parameters
        
        if route.parameters == nil || route.parameters?.count == 0 {
            parameter = [:]
            
        }
        
        var encoding: ParameterEncoding = JSONEncoding.default
        if route.method == .get
        {
            encoding = URLEncoding.default
        }
        
        print("Method: \t\t", route.method.rawValue)
        print("Path: \t\t\t", path ?? "")
        print("Parameters: \t", parameter ?? [:])
        print("header: \t", self.header)
        
        request(path!, method: route.method,
                parameters: parameter!,
                encoding: encoding,
                headers: self.header)
            .responseData { (response) in
                
                print("Response Status Code: \t", response.response?.statusCode as Any)
                
                if let statusCode = response.response?.statusCode,
                    statusCode != 200
                {
                    print("Status Code: \t", statusCode)
                    
                    switch response.result
                    {
                    case .success(let value) :
                        
                        if var resError = try? JSONDecoder().decode(ErrorResponse.self, from: value)
                        {
                            resError.code  = Generic(statusCode)
                            failureCompletion(WebError.unknown, resError)
                        }
                        else
                        {
                            failureCompletion(WebError.parseFail, nil)
                        }
                        
                    case .failure :
                        failureCompletion(WebError.unknown, nil) // Custom Error
                    }
                    
                    return
                }
                else// 200 status , success
                {
                    print("Response: \t", String(data: response.data!, encoding: .utf8) ?? "")

                    if let data = response.data, let resp = try? JSONDecoder().decode(type.self, from: data)
                    {
                        successCompletion(resp)
                    }
                    else
                    {
                        if let success = SuccessRespose(status: "") as? T
                        {
                            successCompletion(success)
                        }
                        else
                        {
                            failureCompletion(WebError.unknown, nil)
                        }
                    }
                }
        }
    }
    
    
    func sendMultiPartRequest<T: Codable>(_ route : Router, type: T.Type, retryCount : Int = 3, fileData : Data, fileName : String, successCompletion : @escaping (_ response: T) -> Void, failureCompletion: @escaping ( _ failure: WebError,  _ detail: ErrorResponse?) -> Void)
    {
        let path = route.path.addingPercentEncoding(withAllowedCharacters : CharacterSet.urlQueryAllowed)
        var parameter = route.parameters
        
        if route.parameters == nil
        {
            parameter = [:]
        }
        
        self.upload(multipartFormData : { multipartFormData in
            
            multipartFormData.append(fileData, withName : fileName, fileName : fileName, mimeType : mimeTypeForPath(path : fileName))
            
            for (key, value) in parameter!
            {
                multipartFormData.append(String(describing : value).data(using : .utf8)!, withName : key)
            }
            
        }, usingThreshold : UInt64.init(), to : path!, method : .post, headers : self.multipartHeader, encodingCompletion : { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _) :
                
                upload.responseJSON(completionHandler : { (response) in
                    
                    switch response.result {
                    case .success(let value):
                        
                        if let valueData = value as? Data, let resp = try? JSONDecoder().decode(type.self, from: valueData)
                        {
                            successCompletion(resp)
                        }
                        else
                        {
                            if let success = SuccessRespose(status: "") as? T
                            {
                                successCompletion(success)
                            }
                            else
                            {
                                failureCompletion(WebError.unknown, nil)
                            }
                        }
                        
                    case .failure(let error) :
                        if (error._code == NSURLErrorTimedOut)
                        {
                            failureCompletion(WebError.timeout, nil)
                        }
                        else if (error._code == NSURLErrorCannotConnectToHost)
                        {
                            failureCompletion(WebError.hostFail, nil)
                        }
                        else if (error._code == NSURLErrorCancelled)
                        {
                            failureCompletion(WebError.cancel, nil)
                        }
                        else if (error._code == NSURLErrorNetworkConnectionLost)
                        {
                            failureCompletion(WebError.unknown, nil)
                        }
                        else
                        {
                            failureCompletion(WebError.unknown, nil)
                        }
                    }
                })
                upload.responseString { response in
                    
                } .uploadProgress { progress in
                    
                    print("Upload Progress: \(progress.fractionCompleted)")
                }
            case .failure(let error) :
                if (error._code == NSURLErrorTimedOut)
                {
                    failureCompletion(WebError.timeout, nil)
                }
                else if (error._code == NSURLErrorCannotConnectToHost)
                {
                    failureCompletion(WebError.hostFail, nil)
                }
                else if (error._code == NSURLErrorCancelled)
                {
                    failureCompletion(WebError.cancel, nil)
                }
                else if (error._code == NSURLErrorNetworkConnectionLost)
                {
                    failureCompletion(WebError.unknown, nil)
                }
                else
                {
                    failureCompletion(WebError.unknown, nil)
                }
            }
        })
    }
}



