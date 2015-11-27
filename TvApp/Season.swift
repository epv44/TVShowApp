//
//  Season.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/29/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Season {
    var title: String?
    var description: String?
    var seasonImageURL: String?
    var episodes: JSONArray?
    
    init(json: NSDictionary){
        if let t = json["title"] as? String{
            title = t
        }
        if let d = json["description"] as? String{
            description = d
        }
        if let url = json["season_image_url"] as? String{
            seasonImageURL = url
        }
        if let e = json["episodes"] as? JSONArray{
            episodes = e
        }
    }
}