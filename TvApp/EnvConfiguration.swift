//
//  EnvConfiguration.swift
//  TvApp
//  This class initializes the environment specific variables necessary for the apps operation.
//  The configurations dictionary contains the pertainent parameters which are defined in the 
//  named plist files (Production.plist, Development.plist, etc...) Due to sensitive params they
//  are not contained in version control.
//  Created by Eric Vennaro on 4/16/15.
//  Copyright (c) 2015 Eric Vennaro. All rights reserved.
//

import Foundation

public class EnvConfiguration{
    
    var configurations: NSDictionary
    var envName: String
    
    //constructor, set properties
    init(){
        self.envName = NSBundle.mainBundle().objectForInfoDictionaryKey("Configuration") as! String!
        if let path = NSBundle.mainBundle().pathForResource(envName, ofType: "plist"){
            self.configurations = NSDictionary(contentsOfFile: path) as! Dictionary<String, AnyObject>!
        }else{
            print("Error occured when initializing environment")
            self.configurations = NSDictionary()
        }
    }
    
    public func getConfigurations() -> NSDictionary{
        return configurations
    }
    
    public func getEnvName() -> NSString{
        return envName
    }
}