//
//  Service.swift
//  TvApp
//  This class interacts with the API access level to retrieve items related to the shows object
//  The callback returns the results or an error message.  It is broken into three steps, parse the http response,
//  decode the JSON response, and store the results in the shows array.  The show objects in an array are what is returned
//  Created by Eric Vennaro on 4/20/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

//Get all shows in the database
func getAllShows(callback: NSDictionary -> ()){
    //create http request using the HTTPHelper Struct
    let httpHelper = HTTPHelper()
    let httpRequest = httpHelper.buildRequest("shows/259", method: "GET", authType: HTTPRequestAuthType.HTTPTokenAuth)
    httpHelper.sendRequest(httpRequest, completion: {(data, response, error) in
        
//        //responseResult is Result<Response>
//        let responseResult = Result(error, Response(data: data, urlResponse: response))
//        //Result<NSData>
//        let parsedResponse = responseResult >>> parseResponse
//        let jsonData = parsedResponse >>> decodeJSON <*>
        var jsonArray: NSDictionary = [:]
        do {
            jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
        } catch  {
            print("error trying to convert data to JSON")
        }
        callback(jsonArray)
    })
    
}