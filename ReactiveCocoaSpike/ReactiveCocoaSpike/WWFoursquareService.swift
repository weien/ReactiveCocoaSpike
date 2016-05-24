//
//  WWFoursquareService.swift
//  ReactiveCocoaSpike
//
//  Created by Weien Wang on 5/23/16.
//  Copyright © 2016 Weien Wang. All rights reserved.
//

import UIKit

class WWFoursquareService: NSObject {
    var llCoords: String
    var coordinateComponent: String
    var stringBase: String
    
    let foursquareBase = "https://api.foursquare.com/v2/venues/search?"
    let foursquareClientIDComponent = "client_id=\(kFoursquareClientID)"
    let foursquareClientSecretComponent = "client_secret=\(kFoursquareClientSecret)"
    let foursquareVersionComponent = "v=\(kFoursquareVersionDate)"
    
    init(llCoords: String) {
        self.llCoords = llCoords
        self.coordinateComponent =  "ll=\(llCoords)"
        self.stringBase = "\(foursquareBase)\(foursquareClientIDComponent)&\(foursquareClientSecretComponent)&\(foursquareVersionComponent)&\(coordinateComponent)" //https://api.foursquare.com/v2/venues/search?client_id=CLIENT_ID&client_secret=CLIENT_SECRET&v=YYYYMMDD&ll=40.7,-74
    }
    
    func urlRequestForSearchTerm(searchTerm: String) -> NSURLRequest {
        let fullString = "\(self.stringBase)&query=\(searchTerm)"
        let createdURL = NSURL(string: fullString)
        return NSURLRequest(URL: createdURL!)
    }
    
    func venueNamesForResponseData(data: NSData) -> Array<String> {
        do {
            if let foursquareObject = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                if let foursquareVenues = foursquareObject["response"]?["venues"] {
                    if let venueNames = foursquareVenues?.valueForKey("name") {
                        return venueNames as! Array<String>
                    }
                }
            }
        } catch {
            NSLog("Error serializing Foursquare data:\(error)")
            return [String]()
        }
        return [String]()
    }
    
    //No-RAC approach
    func foursquareVenuesMatchingSearchTerm(searchTerm: String) {
        let fullString = "\(stringBase)&query=\(searchTerm)"
        if let createdURL = NSURL(string: fullString) {
            let request = NSURLRequest(URL:createdURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    NSLog("Foursquare fetch error is: ", error!)
                }
                else if (data != nil) {
                    do {
                        if let foursquareObject = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                            if let foursquareVenues = foursquareObject["response"]?["venues"] {
                                let venueNames = foursquareVenues?.valueForKey("name")
                                print("Venues are: ", venueNames)
                            }
                        }
                    } catch {
                        NSLog("Error serializing Foursquare data:\(error)")
                    }
                }
            })
            task.resume()
        }
    }
}
