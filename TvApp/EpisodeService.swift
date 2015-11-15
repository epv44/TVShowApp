//
//  EpisodeService.swift
//  TvApp
//
//  Created by Eric Vennaro on 4/22/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

//Get currently playing episodes, currently based on EST in API.  API will return a time window for US timezones and
//app will be narrowed down
//func getCurrentEpisodes(callback: (Result<JSONEpisodeArray>) -> ()){
//    var request: String! = "episodes/current"
//    var timeZone: NSString = NSTimeZone.localTimeZone().abbreviation!.lowercaseString
//    if(timeZone.isEqualToString("est") || timeZone.isEqualToString("edt")){
//        request = "episodes/current"
//    }else if(timeZone.isEqualToString("pst") || timeZone.isEqualToString("pdt")){
//        request = "episodes/current?tzone=pst"
//    }else if(timeZone.isEqualToString("cst") || timeZone.isEqualToString("cdt")){
//        request = "episodes/current?tzone=cst"
//    }else if(timeZone.isEqualToString("mst") || timeZone.isEqualToString("mdt")){
//        request = "episodes/current?tzone=mst"
//    }else if(timeZone.isEqualToString("akst") || timeZone.isEqualToString("akst")){
//        request = "episodes/current?tzone=akst"
//    }else if(timeZone.isEqualToString("hst") || timeZone.isEqualToString("hst")){
//        request = "episodes/current?tzone=hst"
//    }
//    //create http request using the HTTPHelper Struct
//    let httpHelper = HTTPHelper()
//    let httpRequest = httpHelper.buildRequest(request, method: "GET", authType: HTTPRequestAuthType.HTTPTokenAuth)
//    httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, response: NSURLResponse!, error:NSError!) in
//        let responseResult = Result(error, Response(data: data, urlResponse: response))
//        let result = responseResult >>> parseResponse
//            >>> decodeJSON
//            >>> Episode.decode
//        callback(result)
//    })
//}