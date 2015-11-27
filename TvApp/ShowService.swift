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
func getAllShows(callback: JSONShowArray -> ()){
    //create http request using the HTTPHelper Struct
    let httpHelper = HTTPHelper()
    let httpRequest = httpHelper.buildRequest("shows", method: "GET", authType: HTTPRequestAuthType.HTTPTokenAuth)
    //process request
    var showsArray : JSONShowArray = []
    httpHelper.sendRequest(httpRequest, completion: {(data, response, error) in
        var jsonArray: NSArray = []
        do {
            jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            //construct models
            for item: AnyObject in jsonArray {
                showsArray.append(Show.init(json: item as! NSDictionary))
            }
        } catch  {
            print("error trying to convert data to JSON")
        }
        callback(showsArray)
    })
    
}