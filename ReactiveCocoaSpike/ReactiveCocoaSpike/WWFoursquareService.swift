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
    
    init(llCoords: String) {
        self.llCoords = llCoords
    }
    
    func foursquareVenuesMatchingSearchTerm(searchTerm: String) {
        let foursquareBase = "https://api.foursquare.com/v2/venues/search?"
        let foursquareClientIDComponent = "client_id=\(kFoursquareClientID)"
        let foursquareClientSecretComponent = "client_secret=\(kFoursquareClientSecret)"
        let foursquareVersionComponent = "v=\(kFoursquareVersionDate)"
        let coordinateComponent = "ll=\(self.llCoords)"
        let stringBase = "\(foursquareBase)\(foursquareClientIDComponent)&\(foursquareClientSecretComponent)&\(foursquareVersionComponent)&\(coordinateComponent)" //https://api.foursquare.com/v2/venues/search?client_id=CLIENT_ID&client_secret=CLIENT_SECRET&v=YYYYMMDD&ll=40.7,-74
        
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
