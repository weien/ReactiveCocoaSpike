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

        let wwfss = WWFoursquareService(llCoords: "51.6,-0.1")
        
        let searchStrings = self.searchTextField.rac_textSignal()
            .toSignalProducer()
            .map { text in text as! String }
        
        let searchResults = searchStrings
            .flatMap(.Latest) { (query: String) -> SignalProducer<(NSData, NSURLResponse), NSError> in
                let urlRequest = wwfss.urlRequestForSearchTerm(query)
                return NSURLSession.sharedSession()
                    .rac_dataWithRequest(urlRequest)
                    .retry(2)
                    .flatMapError { error in
                        print("Network request unsuccessful: \(error)")
                        return SignalProducer.empty
                    }
            }
            .map { (data, URLResponse) -> Array<String> in
                return wwfss.venueNamesForResponseData(data)
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

