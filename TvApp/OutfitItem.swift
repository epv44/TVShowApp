//
//  OutfitItem.swift
//  TvApp
//
//  Created by Eric Vennaro on 6/6/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct OutfitItem {
    let name: String
    let description: String
    let price: String
    let purchaseUrl: String
    
    static func create(name: String)(description: String)(price: String)(purchaseUrl: String) -> OutfitItem {
        return OutfitItem(name: name, description: description, price: price, purchaseUrl: purchaseUrl)
    }
    
    static func decode(json: JSON) -> Result<JSONOutfitItemArray> {
        var allOutfitItems : JSONOutfitItemArray = []
        
        for obj: AnyObject in JSONObject(json) {
            let outfitItem = OutfitItem.create <^>
                obj["name"]             >>> JSONString <*>
                obj["description"]      >>> JSONString <*>
                obj["price"]            >>> JSONString <*>
                obj["purchase_url"]     >>> JSONString
            allOutfitItems.append(outfitItem!)
        }
        return resultFromOptional(allOutfitItems, NSError())
    }
}