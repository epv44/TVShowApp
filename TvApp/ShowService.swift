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
func getAllShows(callback: (Result<JSONShowArray>) -> ()){
    //create http request using the HTTPHelper Struct
    let httpHelper = HTTPHelper()
    let httpRequest = httpHelper.buildRequest("shows", method: "GET", authType: HTTPRequestAuthType.HTTPTokenAuth)
    httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, response: NSURLResponse!, error:NSError!) in
        let responseResult = Result(error, Response(data: data, urlResponse: response))
        let result = responseResult >>> parseResponse
            >>> decodeJSON
            >>> Show.decode
        callback(result)
    })
}