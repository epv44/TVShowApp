//
//  Season.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/29/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Season {
    let name: String
    let description: String
    let episodes: JSONArray
    
    static func create(name: String)(description: String)(episodes: JSONArray) -> Season {
        //var timeStamp : NSDate = convertToNSDateTime(viewTime)
        return Season(name: name, description: description, episodes:episodes)
    }
    
    static func decode(json: JSON) -> Result<JSONSeasonArray> {
        var allSeasons : JSONSeasonArray = []
        
        for obj: AnyObject in JSONObject(json) {
            let season = Season.create <^>
                obj["title"]        >>> JSONString <*>
                obj["description"]  >>> JSONString <*>
                obj["episodes"]     >>> JSONObject
            allSeasons.append(season!)
        }
        return resultFromOptional(allSeasons, NSError())
    }
}