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
    let episodeImage: String
    let viewingTime: String
    let episodeId: String
    let characters: JSONArray

    static func create(name: String)(description: String)(episodeImage: String)(viewingTime: String)(episodeId: String)(characters: JSONArray) -> Episode {
        return Episode(name: name, description: description, episodeImage: episodeImage, viewingTime: viewingTime, episodeId: episodeId, characters: characters)
    }
    
    static func create1(name: String)(description: String)(episodeImage: String)(episodeId: String)(characters: JSONArray) -> Episode {
        var viewingTime: String = "blank" 
        return Episode(name: name, description: description, episodeImage: episodeImage, viewingTime: viewingTime, episodeId: episodeId, characters: characters)
    }
    
    static func decode(json: JSON) -> Result<JSONEpisodeArray> {
        var allEpisodes : JSONEpisodeArray = []
        
        for obj: AnyObject in JSONObject(json) {
            let episode = Episode.create <^>
                obj["title"]                >>> JSONString <*>
                obj["description"]          >>> JSONString <*>
                obj["episode_image_url"]    >>> JSONString <*>
                obj["viewing_time"]         >>> JSONString <*>
                obj["id"]                   >>> JSONString <*>
                obj["characters"]           >>> JSONObject
            allEpisodes.append(episode!)
        }
        return resultFromOptional(allEpisodes, NSError())
    }
}