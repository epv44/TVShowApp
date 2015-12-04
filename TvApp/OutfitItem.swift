//
//  OutfitItem.swift
//  TvApp
//
//  Created by Eric Vennaro on 6/6/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

struct OutfitItem {
    var itemName: String?
    var description: String?
    var purchaseUrl: String?
    var price: String?
    var retailer: String?
    var itemImageURL: String?
    
    init(json: NSDictionary){
        if let i = json["name"] as? String{
            self.itemName = i
        }
        if let d = json["description"] as? String{
            self.description = d
        }
        if let pURL = json["purchase_url"] as? String{
            self.purchaseUrl = pURL
        }
        if let money = json["price"] as? String {
            self.price = money
        }
        if let r = json["retailer"] as? String{
            self.retailer = r
        }
        if let url = json["piece_image_url"] as? String{
            self.itemImageURL = url
        }
    }
}