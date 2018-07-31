//
//  StarflightTimePreference.swift
//
//  Created by Ankush Kushwaha on 8/1/18.
//  Copyright © 2018 Ankush Kushwaha. All rights reserved.
//

import Foundation

struct StarflightTimePreference {
    
    public struct DailyActiveTime {
        let startHour: String
        let startMinute: String
        let endHour: String
        let endMinute: String
        
        func convertedDictionary() -> [String : String] {
            var dict = [String: String]()
            
            dict["start"] = "\(startHour):\(startMinute)"
            dict["end"] = "\(endHour):\(endMinute)"
            
            return dict
        }
    }
    
    var timeZone: String
    let monday: DailyActiveTime?
    let tuesday: DailyActiveTime?
    let wednesday: DailyActiveTime?
    let thursday: DailyActiveTime?
    let friday: DailyActiveTime?
    let saturday: DailyActiveTime?
    let sunday: DailyActiveTime?
    
    func timePrefJson() -> String {
        
        var dict = [String: Any]()
        
        dict["timezone"] = self.timeZone
        
        if let monday = self.monday {
            dict["MONDAY"] = monday.convertedDictionary()
        }
        if let tuesday = self.tuesday {
            dict["TUESDAY"] = tuesday.convertedDictionary()
        }
        if let wednesday = self.wednesday {
            dict["WEDNESDAY"] = wednesday.convertedDictionary()
        }
        if let thursday = self.thursday {
            dict["THRUSDAY"] = thursday.convertedDictionary()
        }
        if let friday = self.friday {
            dict["FRIDAY"] = friday.convertedDictionary()
        }
        if let saturday = self.saturday {
            dict["SATURDAY"] = saturday.convertedDictionary()
        }
        if let sunday = self.sunday {
            dict["SUNDAY"] = sunday.convertedDictionary()
        }
        
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: dict,
            options: .prettyPrinted
            ),
            let json = String(data: theJSONData,
                              encoding: .ascii) {
            // In case of timeZone Europe/Helsinki
            // JSONSerialization adds extra '\' -> 'Europe\/Helsinki',
            // Somehow backend handles this
            // If we need to remove extra '\' then uncomment the following line
            
            // json = json.replacingOccurrences(of: "\\", with: "");
            return json
        } else {
            return ""
        }
    }
}
