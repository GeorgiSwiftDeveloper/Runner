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
    
    static func saveRunObjectsRealm(pace: Int, distance: Double, duration: Int) {
        REALM_QUEUE.sync {
            let run = Run(pace: pace, distance: distance, duration: duration)
            do {
                let realm = try Realm()
                try  realm.write {
                    realm.add(run)
                }
            }catch {
                debugPrint("Some error to realm!")
            }
        }
        
    }
    
    
    static func getAllRuns() -> Results<Run>? {
        do{
            let realm = try Realm()
            var runs = realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: true)
            return runs
        }catch {
            return nil
        }
    }
    
    
}
