//
//  Outfit.swift
//  TvApp
//
//  Created by Eric Vennaro on 6/6/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Outfit {
    let outfitName: String
    let description: String
    let outfitImage: String
    let episodeId: String
    let pieces: JSONArray
    
    static func create(outfitName: String)(description: String)(outfitImage: String)(episodeId: String)(pieces: JSONArray) -> Outfit {
        return Outfit(outfitName: outfitName, description: description, outfitImage: outfitImage, episodeId: episodeId, pieces: pieces)
    }
    
    static func decode(json: JSON) -> Result<JSONOutfitArray> {
        var allOutfits : JSONOutfitArray = []
        
        for obj: AnyObject in JSONObject(json) {
            let outfit = Outfit.create <^>
                obj["outfit_name"]      >>> JSONString <*>
                obj["description"]      >>> JSONString <*>
                obj["outfit_image_url"] >>> JSONString <*>
                obj["episode_id"]       >>> JSONString <*>
                obj["pieces"]           >>> JSONObject
            allOutfits.append(outfit!)
        }
        return resultFromOptional(allOutfits, NSError())
    }
}