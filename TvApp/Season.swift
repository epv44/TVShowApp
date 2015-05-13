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
    let seasonImage: String
    let episodes: JSONArray
    
    static func create(name: String)(description: String)(seasonImage: String)(episodes: JSONArray) -> Season {
        return Season(name: name, description: description, seasonImage: seasonImage, episodes: episodes)
    }
    
    static func decode(json: JSON) -> Result<JSONSeasonArray> {
        var allSeasons : JSONSeasonArray = []
        
        for obj: AnyObject in JSONObject(json) {
            let season = Season.create <^>
                obj["title"]                >>> JSONString <*>
                obj["description"]          >>> JSONString <*>
                obj["season_image_url"]     >>> JSONString <*>
                obj["episodes"]             >>> JSONObject
            allSeasons.append(season!)
        }
        return resultFromOptional(allSeasons, NSError())
    }
}