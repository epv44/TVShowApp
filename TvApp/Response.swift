//
//  Response.swift
//  TvApp
//
//  Created by Eric Vennaro on 11/14/15.
//  Copyright © 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Response{
    let data: NSData
    var statusCode: Int = 500
    
    init(data: NSData, urlResponse: NSURLResponse) {
        self.data = data
        if let httpResponse = urlResponse as? NSHTTPURLResponse{
            statusCode = httpResponse.statusCode
        }
    }
}