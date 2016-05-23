//
//  ViewController.swift
//  ReactiveCocoaSpike
//
//  Created by Weien Wang on 5/23/16.
//  Copyright © 2016 Weien Wang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
    @IBOutlet var searchTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let wwfss = WWFoursquareService(llCoords: "40.7,-74")
        //wwfss.foursquareVenuesMatchingSearchTerm("pizza")
        
        let searchStrings = self.searchTextField.rac_textSignal()
            .toSignalProducer()
            .map { text in text as! String }
        
        let searchResults = searchStrings
            .flatMap(.Latest) { (query: String) -> SignalProducer<(NSData, NSURLResponse), NSError> in
                let fullString = "\(wwfss.stringBase)&query=\(query)"
                let createdURL = NSURL(string: fullString)
                let URLRequest = NSURLRequest(URL: createdURL!)
                return NSURLSession.sharedSession().rac_dataWithRequest(URLRequest)
            }
            .map { (data, URLResponse) -> Array<String> in
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
                }
                return [String]()
            }
            .observeOn(UIScheduler())
        
        searchResults.startWithNext { results in
            print("Search results: \(results)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

