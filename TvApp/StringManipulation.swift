//
//  StringManipulation.swift
//  TvApp
//
//  Created by Eric Vennaro on 5/11/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation
import Darwin

func lastIndexOf(src:String, target:String) -> Int? {
    let characters = Array(src.characters)
    var index = 0
    var lastIndexOf = 0
    
    for char in characters{
        if String(char) == target {
            lastIndexOf = index
        }
        index++
    }
    
    return lastIndexOf
}

func getImageNameFromUrl(urlString: String) -> String {
    return urlString.substringFromIndex(urlString.startIndex.advancedBy(lastIndexOf(urlString, target: "/")!))
}