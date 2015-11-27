//
//  JSONParser.swift
//  TvApp
//
//  Created by Eric Vennaro on 11/14/15.
//  Copyright © 2015 Eric Vennaro. All rights reserved.
//

import Foundation


typealias JSON = AnyObject
typealias JSONShowArray = Array<Show>
typealias JSONEpisodeArray = Array<Episode>
typealias JSONCharacterArray = Array<Character>
typealias JSONDictionary = Dictionary<String, AnyObject>
typealias JSONArray = NSArray
typealias JSONSeasonArray = Array<Season>
typealias JSONOutfitArray = Array<Outfit>
typealias JSONOutfitItemArray = Array<OutfitItem>

func JSONString(object: JSON) -> String? {
    return object as? String
}

func JSONObject(object: JSON?) -> NSArray {
    return object as! JSONArray!
}

//func decodeJSON(data: NSData) -> Result<JSON> {
//    let jsonOptional =  NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions(0), error: nil) as! NSArray!
//    return resultFromOptional(jsonOptional, NSError())
//}