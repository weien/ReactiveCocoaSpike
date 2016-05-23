//
//  ViewController.swift
//  ReactiveCocoaSpike
//
//  Created by Weien Wang on 5/23/16.
//  Copyright © 2016 Weien Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let wwfss = WWFoursquareService(llCoords: "40.7,-74")
        wwfss.foursquareVenuesMatchingSearchTerm("pizza")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

