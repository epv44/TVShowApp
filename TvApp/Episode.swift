//
//  Episode.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/22/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Episode {
    let name: String
    let description: String
    let viewingTime: String

    static func create(name: String)(description: String)(viewingTime: String) -> Episode {
        return Episode(name: name, description: description, viewingTime:viewingTime)
    }
    static func create1(name: String)(description: String) -> Episode {
        var viewingTime: String = "blank" 
        return Episode(name: name, description: description, viewingTime: viewingTime)
    }
    
    
    static func decode(json: JSON) -> Result<JSONEpisodeArray> {
        var allEpisodes : JSONEpisodeArray = []
        
        for obj: AnyObject in JSONObject(json) {
            let episode = Episode.create <^>
                obj["title"]        >>> JSONString <*>
                obj["description"]  >>> JSONString <*>
                obj["viewing_time"] >>> JSONString
            allEpisodes.append(episode!)
        }
        return resultFromOptional(allEpisodes, NSError())
    }
}