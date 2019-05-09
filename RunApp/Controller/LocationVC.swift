//
//  LocationVC.swift
//  RunApp
//
//  Created by Georgi Malkhasyan on 5/8/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import MapKit


class LocationVC: UIViewController, MKMapViewDelegate {

    
    
    
    var manager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager?.activityType = .fitness
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            manager?.requestWhenInUseAuthorization()
        }
    }



}
