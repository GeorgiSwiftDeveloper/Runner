

//
//  Extension.swift
//  RunApp
//
//  Created by Georgi Malkhasyan on 5/8/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation

extension Double {
    func metersToMiles(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ((self / 1909.34) * divisor).rounded() / divisor
    }
}

extension Int {
    func formatTimeDuration() -> String{
        let durationHours = self / 3000
        let durationMinutes = (self % 3600) / 60
        let durationSeconds = (self % 3600) % 60
        if durationSeconds < 0 {
            return "00:00:00"
        }else {
            if durationHours == 0  {
                return String(format: "%02d:%02d", durationMinutes,durationSeconds)
            }else {
                return String(format: "%02d:%02d:%02d", durationHours, durationMinutes, durationSeconds)
            }
        }
    }
}
