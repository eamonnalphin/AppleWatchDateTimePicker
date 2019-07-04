//
//  WatchHelper.swift
//  DateTimePicker WatchKit Extension
//
//  Created by Eamonn Alphin on 2019-07-04.
//  Copyright © 2019 Eamonn Alphin. All rights reserved.
//

import Foundation
import UIKit





class WatchHelper {
    
    //MARK: - CONVERSIONS
    
    class func convertNSDateTimeToString(_ rawTimeValue:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy h:mm:ss a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let timeString = formatter.string(from: rawTimeValue)
        return timeString
        
    }
    
    
    
    class func convertNSDateTimeToStringDate(_ rawTimeValue:Date) -> String {
        //print("converting date to string")
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let timeString = formatter.string(from: rawTimeValue)
        return timeString
        
    }
    
    class func convertNSDateTimeToStringTime(_ rawTimeValue:Date) -> String {
        //print("converting time to string")
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let timeString = formatter.string(from: rawTimeValue)
        return timeString
    }
    
    
    
    
    /// Converts a day, month and year into a Date
    /// - Parameter Day: <#Day description#>
    /// - Parameter Month: <#Month description#>
    /// - Parameter Year: <#Year description#>
    class func createDateFromDayMonthYear(Day:Int, Month:Int, Year:Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = Year
        dateComponents.month = Month
        dateComponents.day = Day
        dateComponents.timeZone = TimeZone.autoupdatingCurrent
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents) ?? Date()
        return someDateTime
    }
    
    
    /// Converts an hour, minute, and second into a time.
    /// - Parameter H: <#H description#>
    /// - Parameter M: <#M description#>
    /// - Parameter S: <#S description#>
    class func createTimeFromHMS(H:Int, M:Int, S:Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.hour = H
        dateComponents.minute = M
        dateComponents.second = S
        dateComponents.timeZone = TimeZone.autoupdatingCurrent
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents) ?? Date()
        return someDateTime
    }
    
    
    /// Creates a date from all the parts of a date and time
    /// - Parameter day: <#day description#>
    /// - Parameter month: <#month description#>
    /// - Parameter year: <#year description#>
    /// - Parameter hour: <#hour description#>
    /// - Parameter minute: <#minute description#>
    /// - Parameter second: <#second description#>
    class func createTimeFromParts(second:Int, minute:Int, hour:Int, day:Int, month:Int, year:Int) ->Date{
        
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        dateComponents.timeZone = TimeZone.autoupdatingCurrent
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents) ?? Date()
        return someDateTime
    }
    
    
    
    /// Gets the specified component of a date and returns it as an int
    /// - Parameter thisDate: <#thisDate description#>
    /// - Parameter thisComponent: <#thisComponent description#>
    class func getComponentOfDate(_ thisDate:Date, thisComponent:Calendar.Component)->Int{
        let thisPart = Calendar.current.component(thisComponent, from: thisDate)
        return thisPart
    }
    
    
    
    /// Removes all objects from userdefaults
    class func resetCache(){
        if (UserDefaults.standard.object(forKey: "ChosenDate") != nil) {
            print("object exists!")
            UserDefaults.standard.removeObject(forKey: "ChosenDate")
        }
        
        if (UserDefaults.standard.object(forKey: "ChosenTime") != nil) {
            print("object exists!")
            UserDefaults.standard.removeObject(forKey: "ChosenTime")
        }
    }
    
    
    
    
    
}
