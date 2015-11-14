//
//  HTTPHelper.swift
//  Handle HTTP Connections to Rails API.
//  Created by Eric Vennaro on 4/16/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

enum HTTPRequestAuthType {
    case HTTPBasicAuth
    case HTTPTokenAuth
}

enum HTTPRequestContentType {
    case HTTPJsonContent
    case HTTPMultipartContent
}


func parseResponse(response: Response) -> Result<NSData> {
    let successRange = 200..<300
    if !contains(successRange, response.statusCode) {
        return .Error(NSError()) // customize the error message to your liking
    }
    return Result(nil, response.data)
}

struct HTTPHelper {
    static let configVars = EnvConfiguration().getConfigurations()
    static let API_AUTH_NAME = "<YOUR_HEROKU_API_ADMIN_NAME>"
    static let API_AUTH_PASSWORD = "<YOUR_HEROKU_API_PASSWORD>"
    static let BASE_URL = configVars["ROOT_URL"] as? String
    static let API_TOKEN = configVars["API_TOKEN"] as? String
    
    func buildRequest(path: String!, method: String, authType: HTTPRequestAuthType,
        requestContentType: HTTPRequestContentType = HTTPRequestContentType.HTTPJsonContent, requestBoundary:NSString = "") -> NSMutableURLRequest {
            // 1. Get config vars and create the request URL from path
            let configVars = EnvConfiguration().getConfigurations()
            var baseUrl : String!
            var apiToken : String!
            apiToken = configVars["API_TOKEN"] as? String!
            baseUrl = configVars["ROOT_URL"] as? String!
            let requestURL = NSURL(string: "\(baseUrl)/\(path)")
            var request = NSMutableURLRequest(URL: requestURL!)
            
            // Set HTTP request method and Content-Type
            request.HTTPMethod = method
            
            // 2. Set the correct Content-Type for the HTTP Request. This will be multipart/form-data for photo upload request and application/json for other requests in this app
            switch requestContentType {
            case .HTTPJsonContent:
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            case .HTTPMultipartContent:
                let contentType = NSString(format: "multipart/form-data; boundary=%@", requestBoundary)
                request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            }
            
            // 3. Set the correct Authorization header.
            switch authType {
            case .HTTPBasicAuth:
                // Set BASIC authentication header
                let basicAuthString = "\(HTTPHelper.API_AUTH_NAME):\(HTTPHelper.API_AUTH_PASSWORD)"
                let utf8str = basicAuthString.dataUsingEncoding(NSUTF8StringEncoding)
                let base64EncodedString = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
                
                request.addValue("Basic \(base64EncodedString!)", forHTTPHeaderField: "Authorization")
            case .HTTPTokenAuth:
                // Retreieve Auth_Token from Keychain
                //let userToken : NSString? = KeychainAccess.passwordForAccount("Auth_Token", service: "KeyChainService")
                // Set Authorization header
                request.addValue("Token token=\(apiToken)", forHTTPHeaderField: "Authorization")
            }
            
            return request
    }
    
    
    func sendRequest(request: NSURLRequest, completion:(NSData!, NSURLResponse!, NSError!) -> Void) -> () {
        // Create a NSURLSession task
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData!, response: NSURLResponse!, error: NSError!) in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(data, response, error)
                })
                
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let httpResponse = response as! NSHTTPURLResponse
                
                if httpResponse.statusCode == 200 {
                    completion(data, response, nil)
                } else {
//                    var jsonerror:NSError?
//                    let errorDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error:&jsonerror) as NSDictionary
//                    
//                    let responseError : NSError = NSError(domain: "HTTPHelperError", code: httpResponse.statusCode, userInfo: errorDict)
                    completion(data, response, error)
                }
            })
        }
        
        // start the task
        task.resume()
    }
}

