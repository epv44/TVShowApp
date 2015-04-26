//
//  JSONParser.swift
//  TvApp
//  The typealiases here are used throughout this app in order to simplify refering to different swift types
//  Decode the JSON response for the various objects.
//  Created by Eric Vennaro on 4/20/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

typealias JSON = AnyObject
typealias JSONShowArray = Array<Show>
typealias JSONEpisodeArray = Array<Episode>
typealias JSONDictionary = Dictionary<String, AnyObject>
typealias JSONArray = NSArray

func JSONString(object: JSON) -> String? {
    return object as? String
}

func JSONObject(object: JSON?) -> NSArray {
    return object as JSONArray!
}

func decodeJSON(data: NSData) -> Result<JSON> {
    let jsonOptional =  NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions(0), error: nil) as NSArray!
    return resultFromOptional(jsonOptional, NSError())
}