//
//  CurrentRunVC.swift
//  RunApp
//
//  Created by Georgi Malkhasyan on 5/8/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import  MapKit



class CurrentRunVC: LocationVC {

    @IBOutlet weak var swipeBGImageView: UIImageView!
 
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var praceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var timer = Timer()
    
    var runDistance = 0.0
    var pace = 0
    var counter = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        
        manager?.distanceFilter = 10
          startRun()
        
        
    }

    func startRun() {
        manager?.startUpdatingLocation()
        startTimer()
        pauseBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
    }
    
    
    func endRun() {
        manager?.stopUpdatingLocation()
        Run.saveRunObjectsRealm(pace: pace, distance: runDistance, duration: counter)
    }
    
    
    func pauseRun() {
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseBtn.setImage(UIImage(named: "resumeButton"), for: .normal)
    }
    func startTimer()  {
        durationLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCoundet), userInfo: nil, repeats: true)
    }
    
    
    @objc func  updateCoundet() {
        counter += 1
        durationLbl.text = counter.formatTimeDuration()
    }
    
    func calculatePace(time second: Int, miles: Double) -> String  {
        pace = Int(Double(second) / miles)
        return pace.formatTimeDuration()
    }
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        if timer.isValid  {
             pauseRun()
        }else {
            startRun()
        }
       
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @objc func endRunSwiped(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 126
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (swipeBGImageView.center.x - minAdjust)  && sliderView.center.x <= (swipeBGImageView.center.x + maxAdjust){
                    sliderView.center.x = sliderView.center.x + translation.x
                }else if sliderView.center.x >= (swipeBGImageView.center.x + maxAdjust) {
                    sliderView.center.x = swipeBGImageView.center.x + maxAdjust
                    endRun()
                    dismiss(animated: true, completion: nil)
                }else {
                    sliderView.center.x = swipeBGImageView.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            }else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.swipeBGImageView.center.x - minAdjust
                }
            }
        }
    }


}


extension CurrentRunVC: CLLocationManagerDelegate  {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse  {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        }else  if let location = locations.last{
            runDistance += lastLocation.distance(from: location)
            distanceLbl.text = "\(runDistance.metersToMiles(places: 2))"
            if counter > 0 && runDistance > 0 {
                praceLbl.text = calculatePace(time: counter, miles: runDistance.metersToMiles(places: 2))
            }
        }
        lastLocation = locations.last
    }
}
