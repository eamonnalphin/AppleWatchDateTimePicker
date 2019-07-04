//
//  DateTimePicker.swift
//  DateTimePicker WatchKit Extension
//
//  Created by Eamonn Alphin on 2019-07-04.
//  Copyright © 2019 Eamonn Alphin. All rights reserved.
//

import Foundation
import WatchKit

class DateTimePicker: WKInterfaceController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var DateLabel: WKInterfaceLabel!
    @IBOutlet weak var LeftPicker: WKInterfacePicker!
    @IBOutlet weak var MiddlePicker: WKInterfacePicker!
    @IBOutlet weak var RightPicker: WKInterfacePicker!
    
    
    //MARK: VARIABLES
    
    var LeftPickerItems:[WKPickerItem] = [] //items in the left picker
    var MiddlePickerItems:[WKPickerItem] = [] //items in the middle picker
    var RightPickerItems:[WKPickerItem] = [] //items in the right picker
    
    
    var defaultDate:Date! //a fallback in case a value can't be found for some reason.
    let myCalendar = Calendar.current //the current system calendar, used for getting components.
    
    //for determining which pickers to display.
    enum PickerType {
        case Date //the user wants to pick a date
        case Time //the user wants to pick a time
        case None //a picker has not been assigned yet.
    }
    
    var choosingType:PickerType = .None //start off with none, it'll get assigned on waking.
    
    var chosenDate:Date! //the date the user chose.
    var chosenDay:Int = 1
    var chosenMonth:Int = 1
    var chosenYear:Int = 1
    
    var chosenTime:Date!
    var chosenHour:Int = 1
    var chosenMinute:Int = 1
    var chosenSecond:Int = 1
    
    
    //MARK: PICKER CHANGES
    
    @IBAction func LeftPickerChanged(_ value: Int) {
        let leftPickerValue = LeftPickerItems[value]
        if choosingType == .Date {
            chosenDay = Int(leftPickerValue.title ?? "1") ?? WatchHelper.getComponentOfDate(defaultDate, thisComponent: Calendar.Component.day)
            chosenDate = WatchHelper.createDateFromDayMonthYear(Day: chosenDay, Month: chosenMonth, Year: chosenYear)
            DateLabel.setText(WatchHelper.convertNSDateTimeToStringDate(chosenDate))
            saveDateLocally()
        } else {
            chosenHour = Int(leftPickerValue.title ?? "1") ?? WatchHelper.getComponentOfDate(defaultDate, thisComponent: Calendar.Component.hour)
            chosenTime = WatchHelper.createTimeFromHMS(H: chosenHour, M: chosenMinute, S: chosenSecond)
            DateLabel.setText(WatchHelper.convertNSDateTimeToStringTime(chosenTime))
            saveTimeLocally()
            
        }
        
    }
    
    @IBAction func MiddlePickerChanged(_ value: Int) {
        let middlePickerValue = MiddlePickerItems[value]
        if choosingType == .Date {
            chosenMonth = Int(middlePickerValue.title ?? "1") ?? WatchHelper.getComponentOfDate(defaultDate, thisComponent: Calendar.Component.month)
            chosenDate = WatchHelper.createDateFromDayMonthYear(Day: chosenDay, Month: chosenMonth, Year: chosenYear)
            
            setDaysPicker(thisDate: chosenDate) //update for month change.
            DateLabel.setText(WatchHelper.convertNSDateTimeToStringDate(chosenDate))
            saveDateLocally()
        } else {
            chosenMinute = Int(middlePickerValue.title ?? "1") ?? WatchHelper.getComponentOfDate(defaultDate, thisComponent: Calendar.Component.minute)
            chosenTime = WatchHelper.createTimeFromHMS(H: chosenHour, M: chosenMinute, S: chosenSecond)
            DateLabel.setText(WatchHelper.convertNSDateTimeToStringTime(chosenTime))
            saveTimeLocally()
        }
        
        
        
    }
    
    @IBAction func RightPickerChanged(_ value: Int) {
        let rightPickerValue = RightPickerItems[value]
        if choosingType == .Date {
            let defaultYear = WatchHelper.getComponentOfDate(defaultDate, thisComponent: Calendar.Component.year)
            chosenYear = Int(rightPickerValue.caption ?? "\(defaultYear)") ?? WatchHelper.getComponentOfDate(defaultDate, thisComponent: Calendar.Component.year)
            chosenDate = WatchHelper.createDateFromDayMonthYear(Day: chosenDay, Month: chosenMonth, Year: chosenYear)
            
            setDaysPicker(thisDate: chosenDate) //update for leap years.
            DateLabel.setText(WatchHelper.convertNSDateTimeToStringDate(chosenDate))
            saveDateLocally()
        } else {
            chosenSecond = Int(rightPickerValue.title ?? "1") ?? WatchHelper.getComponentOfDate(defaultDate, thisComponent: Calendar.Component.second)
            chosenTime = WatchHelper.createTimeFromHMS(H: chosenHour, M: chosenMinute, S: chosenSecond)
            DateLabel.setText(WatchHelper.convertNSDateTimeToStringTime(chosenTime))
            saveTimeLocally()
        }
        
    }
    
    
    //MARK: GETTING DATES
    
    
    /// Calculates the number of days in the given month of the given year
    /// - Parameter Month: <#Month description#>
    func numDaysInMonthOfYear(Month:Int, Year:Int)->Int{
        let dateComponents = DateComponents(year: Year, month: Month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    
    /// Returns an array containing the day numbers for the month and year
    /// - Parameter Month: <#Month description#>
    /// - Parameter Year: <#Year description#>
    func getDaysInMonthAndYear(Month:Int, Year:Int)->[Int]{
        var daysArray:[Int] = []
        let numDays = numDaysInMonthOfYear(Month: Month, Year: Year)
        for i in 1...numDays {
            daysArray.append(i)
        }
        return daysArray
    }
    
    
    
    
    
    
    /// The number of days will vary by month and year
    /// - Parameter thisDate: <#thisDate description#>
    func setDaysPicker(thisDate:Date){
        print("resetting day picker")
        
        LeftPickerItems = []
        let thisDay = WatchHelper.getComponentOfDate(thisDate, thisComponent: Calendar.Component.day)
        let thisMonth = WatchHelper.getComponentOfDate(thisDate, thisComponent: Calendar.Component.month)
        let thisYear = WatchHelper.getComponentOfDate(thisDate, thisComponent: Calendar.Component.year)
        
        let days = getDaysInMonthAndYear(Month: thisMonth, Year: thisYear)
        for day in days {
            let thisPickerItem:WKPickerItem = WKPickerItem()
            thisPickerItem.title = "\(day)"
            LeftPickerItems.append(thisPickerItem)
        }
        LeftPicker.setItems(LeftPickerItems)
        if(thisDay-1 < LeftPickerItems.count){
            LeftPicker.setSelectedItemIndex(thisDay-1)
        } else {
            LeftPicker.setSelectedItemIndex(LeftPickerItems.count-1)
        }
        
        
    }
    
    
    //MARK: SET PICKERS FOR DATE
    
    
    /// populates the pickers and sets them to the given date
    func setPickersForDates(thisDate:Date){
        let thisMonth = WatchHelper.getComponentOfDate(thisDate, thisComponent: Calendar.Component.month)
        let thisYear = WatchHelper.getComponentOfDate(thisDate, thisComponent: Calendar.Component.year)
        
        
        //the leftmost picker: the day
        setDaysPicker(thisDate: thisDate)
        
        
        
        //the middle picker, the months
        for month in 1...12 {
            let thisPickerItem:WKPickerItem = WKPickerItem()
            thisPickerItem.title = "\(month)"
            MiddlePickerItems.append(thisPickerItem)
        }
        
        MiddlePicker.setItems(MiddlePickerItems)
        MiddlePicker.setSelectedItemIndex(thisMonth-1)
        
        
        
        //the right picker, the years
        for i in thisYear-10...thisYear+10{
            let thisPickerItem:WKPickerItem = WKPickerItem()
            
            let yearVal = i
            var yearStr = "\(yearVal)"
            yearStr = String(yearStr.dropFirst(2))
            
            thisPickerItem.title = yearStr
            thisPickerItem.caption = "\(yearVal)"
            RightPickerItems.append(thisPickerItem)
        }
        RightPicker.setItems(RightPickerItems)
        RightPicker.setSelectedItemIndex(10)
        
    }
    
    
    
    /// Saves the set value to user defaults so it can be repulled on the previous screen
    func saveDateLocally(){
        //save to NSUserDefaults
        print("value saved")
        UserDefaults.standard.set(chosenDate, forKey: "ChosenDate")
    }
    
    
    /// Saves the set value to user defaults so it can be repulled on the previous screen
    func saveTimeLocally(){
        print("value saved")
        UserDefaults.standard.set(chosenTime, forKey: "ChosenTime")
    }
    
    
    
    //MARK: SET PICKERS FOR TIME
    func setPickersForTime(thisTime: Date){
        print("setting pickers for Time")
        LeftPickerItems = []
        MiddlePickerItems = []
        RightPickerItems = []
        
        let thisHour = WatchHelper.getComponentOfDate(thisTime, thisComponent: Calendar.Component.hour)
        let thisMinute = WatchHelper.getComponentOfDate(thisTime, thisComponent: Calendar.Component.minute)
        let thisSecond = WatchHelper.getComponentOfDate(thisTime, thisComponent: Calendar.Component.second)
        
        
        //the leftmost picker: the hours
        for i in 0...23 {
            let thisPickerItem:WKPickerItem = WKPickerItem()
            thisPickerItem.title = "\(i)"
            LeftPickerItems.append(thisPickerItem)
        }
        LeftPicker.setItems(LeftPickerItems)
        LeftPicker.setSelectedItemIndex(thisHour)
        
        
        //the middle picker, the minutes
        for i in 0...59 {
            let thisPickerItem:WKPickerItem = WKPickerItem()
            thisPickerItem.title = "\(i)"
            MiddlePickerItems.append(thisPickerItem)
        }
        
        MiddlePicker.setItems(MiddlePickerItems)
        MiddlePicker.setSelectedItemIndex(thisMinute)
        
        
        
        //the right picker the seconds
        for i in 0...59 {
            let thisPickerItem:WKPickerItem = WKPickerItem()
            thisPickerItem.title = "\(i)"
            RightPickerItems.append(thisPickerItem)
        }
        
        RightPicker.setItems(RightPickerItems)
        RightPicker.setSelectedItemIndex(thisSecond)
    }
    
    
    //MARK: SET VIEW
    
    //MARK: AWAKE
    override func awake(withContext context: Any?) {
        
        super.awake(withContext: context)
        
        if(context != nil){
            let contextual = context as! Dictionary<String,Date>
            
            if let startDate = contextual["startDate"]{
                defaultDate = startDate
                print("from date.")
                choosingType = .Date
                setPickersForDates(thisDate: startDate)
                DateLabel.setText(WatchHelper.convertNSDateTimeToStringDate(startDate))
            } else {
                //start time
                print("from time.")
                let startTime = contextual["startTime"] ?? Date()
                defaultDate = startTime
                choosingType = .Time
                setPickersForTime(thisTime: startTime)
                DateLabel.setText(WatchHelper.convertNSDateTimeToStringTime(startTime))
                
            }
        }
    }
    
    //MARK: WILLACTIVATE
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    //MARK: DIDDEACTIVATE
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    
    
}
