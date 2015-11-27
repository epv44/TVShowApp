//
//  Character.swift
//  TvApp
//
//  Created by Eric Vennaro on 5/20/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Character{
    var firstName: String?
    var lastName: String?
    var characterImageURL: String?
    var outfitList: JSONArray?
    
    init(json: NSDictionary){
        if let fname = json["first_name"] as? String{
            self.firstName = fname
        }
        if let lname = json["last_name"] as? String{
            self.lastName = lname
        }
        if let url = json["character_image_url"] as? String{
            self.characterImageURL = url
        }
        if let oList = json["outfits"] as? JSONArray{
            self.outfitList = oList
        }
    }
    
}