//
//  Episode.swift
//  TvApp
//
//  Created by Eric Vennaro on 11/14/15.
//  Copyright © 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Episode {
    var title: String?
    var description: String?
    var episodeImageURL: String?
    var viewingTime: String?
    var episodeId: String?
    var characters: JSONArray?
    
    init(json: NSDictionary){
        if let t = json["title"] as? String{
            self.title = t
        }
        if let d = json["description"] as? String{
            self.description = d
        }
        if let url = json["episode_image_url"] as? String{
            self.episodeImageURL = url
        }
        if let v = json["viewing_time"] as? String{
            self.viewingTime = v
        }
        if let id = json["id"] as? String{
            self.episodeId = id
        }
        if let c = json["characters"] as? JSONArray {
            self.characters = c
        }
    }
}