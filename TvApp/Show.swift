//
//  Show.swift
//  TvApp
//  Show object, also contains the function to decode the json string and place show objects in an array
//  Created by Eric Vennaro on 4/20/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Show{
    let name: String
    let description: String
    let seasons: JSONArray
    
    static func create(name: String)(description: String)(seasons: JSONArray) -> Show {
        return Show(name: name, description: description, seasons: seasons)
    }
    
    static func decode(json: JSON) -> Result<JSONShowArray> {
        var allShows : JSONShowArray = []
        
        for obj: AnyObject in JSONObject(json) {
            let show = Show.create <^>
                        obj["title"]       >>> JSONString <*>
                        obj["description"] >>> JSONString <*>
                        obj["seasons"]     >>> JSONObject
            allShows.append(show!)
        }
        return resultFromOptional(allShows, NSError())
    }
}