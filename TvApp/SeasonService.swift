//
//  SeasonService.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/29/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

func getAllSeasons(callback: JSONSeasonArray -> ()){
    //create http request using the HTTPHelper struct
    let httpHelper = HTTPHelper()
    let httpRequest = httpHelper.buildRequest("seasons", method: "GET", authType: HTTPRequestAuthType.HTTPBasicAuth)
    //process request
    var seasonsArray : JSONSeasonArray = []
    httpHelper.sendRequest(httpRequest, completion: {(data, response, error) in
        var jsonArray: NSArray = []
        do {
            jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            //construct models
            for item: AnyObject in jsonArray {
                seasonsArray.append(Season.init(json: item as! NSDictionary))
            }
        } catch {
            print("error converting")
        }
        callback(seasonsArray)
    })
}