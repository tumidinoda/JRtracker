//
//  ViewController.swift
//  JRtracker
//
//  Created by Robert Jonas on 26.06.17.
//  Copyright © 2017 jr-soft. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var myLocMgr = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //ask for permission to use location
        myLocMgr.requestAlwaysAuthorization()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

