//
//  Environment.swift
//  InstaVolt
//
//  Created by PCQ111 on 11/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

enum Server
{
    case developement
    case staging
    case production
}

class Environment
{
    //Add Target conditions here and set defualt server here based on Target.
    //    #if BASEPROJECT_PRODUCTION
    //        static let server:Server    =   .production
    //    #elseif BASEPROJECT_STAGING
    //        static let server:Server    =   .staging
    //    #else
    //        static let server:Server    =   .developement
    //    #endif
    
    static let server:Server    =   .developement
    
    // To print the log set true.
    static let debug:Bool       =   true
    
    //Get Address API
    static let getAddressURL = "https://api.getAddress.io/find/"
    
    class func APIBasePath() -> String
    {
        switch self.server
        {
        case .developement:
            //return "http://ror.anasource.com:8090/cup_o_sugar/api/v1/"
          //   return "https://relevantsync-dev.azurewebsites.net/api/"
            // http://192.168.1.70:2000/v1/
            return "https://dpi.dev.emsp.instavolt.co.uk/v1/"
            
        case .staging:
            return "http://ror.anasource.com:8090/cup_o_sugar/api/v1/"
        case .production:
            return "http://ror.anasource.com:8090/cup_o_sugar/api/v1/"
        }
    }
}


