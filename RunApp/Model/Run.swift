//
//  Run.swift
//  RunApp
//
//  Created by Georgi Malkhasyan on 5/9/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object {
    @objc dynamic var id  = " "
    @objc dynamic var pace = 0
    @objc dynamic var distance = 0.0
    @objc dynamic var duration = 0
    @objc dynamic var date = NSDate()
    
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["pace","date","duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int){
        self.init()
        
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
    }
}
