//
//  Selection.swift
//  DateTimePicker WatchKit Extension
//
//  Created by Eamonn Alphin on 2019-07-04.
//  Copyright © 2019 Eamonn Alphin. All rights reserved.
//

import Foundation
import WatchKit

class Selection: WKInterfaceController{
    var setDateTime:Date = Date() //the final value to be used.
    
    @IBOutlet weak var DateBtn: WKInterfaceButton!
    @IBOutlet weak var TimeBtn: WKInterfaceButton!
    
    
    //MARK: AWAKE
    override func awake(withContext context: Any?) {
        print("IncidentScreen Awake!")
        super.awake(withContext: context)
    }
    
    //MARK: WILLACTIVATE
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        var chosenDate = setDateTime //default to the set date
        var chosenTime = setDateTime //default to the set date
        var chosenValues:[Int] = Array(repeating: 0, count: 6) //will hold the components, in smallest unit to largest
        
        //check for a chosen date.
        if (UserDefaults.standard.object(forKey: "ChosenDate") != nil) {
            print("object exists!")
            chosenDate = UserDefaults.standard.object(forKey: "ChosenDate") as? Date ?? setDateTime
        }
        
        //check for a chosen time.
        if (UserDefaults.standard.object(forKey: "ChosenTime") != nil) {
            print("object exists!")
            chosenTime = UserDefaults.standard.object(forKey: "ChosenTime") as? Date ?? setDateTime
        }
        
        //use the components to build a date.
        chosenValues[0] = WatchHelper.getComponentOfDate(chosenTime, thisComponent: Calendar.Component.second)
        chosenValues[1] = WatchHelper.getComponentOfDate(chosenTime, thisComponent: Calendar.Component.minute)
        chosenValues[2] = WatchHelper.getComponentOfDate(chosenTime, thisComponent: Calendar.Component.hour)
        chosenValues[3] = WatchHelper.getComponentOfDate(chosenDate, thisComponent: Calendar.Component.day)
        chosenValues[4] = WatchHelper.getComponentOfDate(chosenDate, thisComponent: Calendar.Component.month)
        chosenValues[5] = WatchHelper.getComponentOfDate(chosenDate, thisComponent: Calendar.Component.year)
        
        //create a date from the parts.
        setDateTime = WatchHelper.createTimeFromParts(second: chosenValues[0], minute: chosenValues[1], hour: chosenValues[2], day: chosenValues[3], month: chosenValues[4], year: chosenValues[5])
        
        //set the button titles to the value
        DateBtn.setTitle(WatchHelper.convertNSDateTimeToStringDate(setDateTime))
        TimeBtn.setTitle(WatchHelper.convertNSDateTimeToStringTime(setDateTime))
        
    }
    
    //MARK: DIDDEACTIVATE
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    //MARK: SEGUE
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        print("about to segue")
        let starterDate = setDateTime
        
        if(segueIdentifier == "adjDate"){
            return ["startDate":starterDate]
        } else {
            return ["startTime":starterDate]
        }
        
        
    }
    
}
