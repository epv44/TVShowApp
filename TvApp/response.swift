//
//  response.swift
//  TvApp
//  Decodes http response, if error is not included this settles to the default of an internal server error
//  Created by Eric Vennaro on 4/20/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Response{
    let data: NSData
    let statusCode: Int = 500
    
    init(data: NSData, urlResponse: NSURLResponse) {
        self.data = data
        if let httpResponse = urlResponse as? NSHTTPURLResponse{
            statusCode = httpResponse.statusCode
        }
    }
}