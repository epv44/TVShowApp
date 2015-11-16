//
//  Show.swift
//  TvApp
//
//  Created by Eric Vennaro on 11/14/15.
//  Copyright © 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Show{
    var title: String?
    var description: String?
    var showImageURL: String?
    var seasons: JSONArray?
    
    init(json: NSDictionary){
        if let t = json["title"] as? String{
            self.title = t
        }
        if let d = json["description"] as? String{
            self.description = d
        }
        if let url = json["show_image_url"] as? String{
            self.showImageURL = url
        }
        if let s = json["seasons"] as? JSONArray{
            self.seasons = s
        }
    }
}
