//
//  Outfit.swift
//  TvApp
//
//  Created by Eric Vennaro on 6/6/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Outfit {
    var outfitName: String?
    var description: String?
    var outfitImageURL: String?
    var episodeId: String?
    var pieces: JSONArray?
    
    init(json: NSDictionary){
        if let n = json["outfit_name"] as? String{
            self.outfitName = n
        }
        if let d = json["description"] as? String{
            self.description = d
        }
        if let url = json["outfit_image_url"] as? String{
            self.outfitImageURL = url
        }
        if let id = json["episode_id"] as? String{
            self.episodeId = id
        }
        if let p = json["pieces"] as? JSONArray{
            self.pieces = p
        }
        
    }
}