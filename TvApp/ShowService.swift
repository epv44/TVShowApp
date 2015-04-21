//
//  Service.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/20/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

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
