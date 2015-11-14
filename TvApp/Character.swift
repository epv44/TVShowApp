//
//  Character.swift
//  TvApp
//
//  Created by Eric Vennaro on 5/20/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct Character{
    let firstName: String
    let lastName: String
    let outfitList: JSONArray
    let characterImage: String
    
    static func create(firstName: String)(lastName: String)(outfitList: JSONArray)(characterImage: String)-> Character {
        return Character(firstName: firstName, lastName: lastName, outfitList: outfitList, characterImage: characterImage)
    }
    
    static func decode(json: JSON) -> Result<JSONCharacterArray> {
        var allCharacters : JSONCharacterArray = []
        
        for obj: AnyObject in JSONObject(json) {
            let character = Character.create <^>
                obj["first_name"]          >>> JSONString <*>
                obj["last_name"]           >>> JSONString <*>
                obj["outfits"]             >>> JSONObject <*>
                obj["character_image_url"] >>> JSONString
            allCharacters.append(character!)
        }
        return resultFromOptional(allCharacters, NSError())
    }
}