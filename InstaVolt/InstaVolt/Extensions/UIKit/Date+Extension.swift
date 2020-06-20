//
//  Date+Extension.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation

extension Date
{
    var dateToString : String
    {
        return DateFormatter.dateFormater.string(from: self)
    }
    
    
    var dateToStringLongWithMiliSec : String
    {
        return DateFormatter.dateFormaterLongWithMiliSecond.string(from: self)
    }

    
    var dateTotime : String
    {
        return DateFormatter.dateFormatterTime.string(from: self)
    }
    
    
    var eventAPIDateString : String
    {
        return DateFormatter.eventAPIDateFormatter.string(from: self)
    }
    
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


extension Date {
    func convertToTimeZoneGMTtoCurrent() -> Date {
        let initTimeZone: TimeZone = TimeZone.init(abbreviation: "GMT")!
        let timeZone: TimeZone = TimeZone.current
        let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
    func convertToTimeZoneCurrentTOGMT() -> Date {
        let timeZone: TimeZone = TimeZone.init(abbreviation: "GMT")!
        let initTimeZone: TimeZone = TimeZone.current
        let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
    
    func string(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func age() -> Int{
        let now = Date()
        let birthday: Date = self
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        return ageComponents.year ?? 0
    }
}

enum Day:String{
    
    case monday    = "1"
    case tuesday   = "2"
    case wednesday = "3"
    case thrusday  = "4"
    case friday    = "5"
    case saturday  = "6"
    case sunday    = "7"
    
    var title:String{
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thrusday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
        
    }
    
}

enum DateFormatApp {
    
    case birthDate
    case appointmentDate
    case activityTime
    case activityServerDate
    case activityServerTime
    case activityServerDateTime
    case activitySectionDate
    case symlPoolSelectionDate
    case todayDate
    case todayDateSingle
    case fulldate
    case notificationDate
    case fullMonth
    case notificationRemainingTime
    case dateString
    case notificationDateWithSlace
    case fullTime
    case fixFullDate
    case validityDate
    case eventDate
    case walletDate
    case donationDate
    case time
    case weekDay
    case monthandday
    case fullMonthAndDay
    case fsCalendar
    case paramsForMyAppointment
    case cobineDate
    case dateAndTime
    case orderDate
    case orderDateSmall

    var text:String{
        switch self {
        case .paramsForMyAppointment:
            return "YYYY-M-dd"
        case .birthDate:
            return "YYYY-MM-dd"
        case .appointmentDate:
            return "MMM dd, yyyy"
        case .symlPoolSelectionDate:
            return "EEEE, MMMM dd"
        case .activityTime:
            return "h:mm a"
        case .activityServerDate:
            return "yyyy-MM-dd"
        case .activityServerTime:
            return "H:mm"
        case .activityServerDateTime:
            return "yyyy-MM-dd" + " " + "H:mm"
        case .activitySectionDate:
            return "yyyy-MM-dd"
        case .todayDate:
            return "dd"
        case .todayDateSingle:
            return "d"
        case .fulldate:
            return "yyyy-MM-dd HH:mm:ss.SSS"
        case .notificationDate:
            return "MM-dd-yyyy hh:mm:ss a"
        case .fullMonth:
            return "MMMM"
        case .notificationRemainingTime:
            return "yyyy-MM-dd HH:mm:ss Z"
        case .dateString:
            return "dd/MM/yyyy HH:mm"
        case .notificationDateWithSlace:
            return "MM/dd/yyyy hh:mm:ss a"
        case .fullTime:
            return "HH:mm:ss"
        case .fixFullDate:
            return "yyyy-MM-dd HH:mm:ss"
        case .validityDate:
            return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case .eventDate:
            return "EEE dd MMM, yyyy hh:mm a"
        case .walletDate:
            return "d MMM yyyy"
        case .donationDate:
            return "dd MMM, EEE HH:mm"
        case .time:
            return "hh:mm a"
        case .weekDay:
            return "EEE"
        case .monthandday:
            return "d MMM"
        case .fullMonthAndDay:
            return "MMMM d"
        case .fsCalendar:
            return "MMMM yyyy"
        case .cobineDate:
            return "YYYY-M-dd hh:mm a"
        case .dateAndTime:
            return "dd-MM-yyyy hh:mm a"
        case .orderDate:
            return "dd MMMM yyyy"
        case .orderDateSmall:
            return "dd MMM yyyy"
        }
    }
}

struct DateApp {
    
    static func date(fromString stringDate:String ,withFormat format:DateFormatApp) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format.text
        formatter.locale = Locale(identifier: "en_US_POSIX") // For time format.
        formatter.timeZone = TimeZone(abbreviation:"UTC") // for calculate time.
        
        if let date = formatter.date(from: stringDate){
            return date
        }
        return nil
    }
    
    static func dateWithoutUTC(fromString stringDate:String ,withFormat format:DateFormatApp) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format.text
        formatter.locale = Locale(identifier: "en_US_POSIX") // For time format.
        //        formatter.timeZone = TimeZone(abbreviation:"UTC") // for calculate time.
        
        if let date = formatter.date(from: stringDate){
            return date
        }
        return nil
    }
    
    /*
     static func convertUTCDateToLocal(UTCdateString: String,withFormat format:DateFormatApp) -> Date{
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = format.text
     dateFormatter.timeZone = TimeZone(abbreviation:"UTC")
     let date = dateFormatter.date(from: UTCdateString)// create   date from string
     
     // change to a readable time format and change to local time zone
     dateFormatter.dateFormat = format.text
     dateFormatter.timeZone = TimeZone.current
     return dateFormatter.string(from: date!)
     }
     */
    
    static func dateLocal(fromString stringDate:String ,withFormat format:DateFormatApp) -> Date? {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // For time format.
        formatter.dateFormat = format.text
        //        formatter.timeZone = TimeZone.current // for calculate time.
        
        if let date = formatter.date(from: stringDate){
            return date
        }
        return nil
    }
    
    static func getSystemTimeZoneDateFromUTCdate(UTCdate : Date) -> Date?
    {
        let utcTimeZone : TimeZone = TimeZone.init(abbreviation: "UTC")!
        let currentGMTOffset : Int = TimeZone.current.secondsFromGMT(for: UTCdate)
        let gmtOffset : Int = utcTimeZone.secondsFromGMT(for: UTCdate)
        let gmtInterval : TimeInterval = TimeInterval(currentGMTOffset - gmtOffset)
        
        let destinationDate : Date? = Date.init(timeInterval: gmtInterval, since: UTCdate)
        return destinationDate
    }
    
    static func nsDateFromStringForUTC(strDate : String,usingDateFormat dateFormat:String) -> Date?
    {
        let formatter : DateFormatter = DateFormatter.init()
        let locale : Locale = Locale.init(identifier: "en_US_POSIX")
        formatter.locale = locale
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = dateFormat
        let date : Date? = formatter.date(from: strDate)
        return date
    }
    
    static func nsDateFromString(strDate : String,usingDateFormat dateFormat:String) -> Date?
    {
        let formatter : DateFormatter = DateFormatter.init()
        let locale : Locale = Locale.init(identifier: "en_US_POSIX")
        formatter.locale = locale
        formatter.dateFormat = dateFormat
        let date : Date? = formatter.date(from: strDate)
        return date
    }
    
    static func string(fromDate date:Date, withFormat format:DateFormatApp) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format.text
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation:"UTC")
        return formatter.string(from: date)
    }
    
    static func stringWithLocalTime(fromDate date:Date, withFormat format:DateFormatApp) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.text
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    static func stringToDateConvert(fromDate strDate:String, withFormat format:DateFormatApp) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.text
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let date : Date? = formatter.date(from: strDate)
        return date
    }
    
    static func dateToStringConvert(fromDate date:Date, withFormat format:DateFormatApp) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.text
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    static func string(fromString dateString:String, withFormat format:DateFormatApp) -> String {
        let date = self.date(fromString: dateString, withFormat: .activityServerDateTime)
        return self.stringWithLocalTime(fromDate: date!, withFormat: format)
    }
    
    
    
    static func stringFiltered(jumptodate: Date, withFormat format:DateFormatApp) -> String {
        
        let weekday = DateApp.getDay(weekDay: Calendar.current.component(.weekday, from: jumptodate)).title
        
        plog(weekday)
        
        if Calendar.current.isDate(Date(), inSameDayAs:jumptodate) {
            plog("Today?: \(true))")
            return "Today"
        }
        if let tomorrowsDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()), Calendar.current.isDate(tomorrowsDate, inSameDayAs:jumptodate) {
            plog("Tomorrow?: \(true))")
            return "Tomorrow"
        }
        
        //        plog("date sent: \(date) \(jumptodate.getOnlyDate())")
        //        return "\(weekday), \(jumptodate.getMonthName()) \(jumptodate.getOnlyDate()), \(jumptodate.getOnlyYear())"
        return "\(weekday)"
        
    }
    
    static func getDay(weekDay:Int) -> Day{
        
        switch weekDay {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thrusday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            return .sunday
        }
    }
    
    static func getTimeDifference(startDate:Date, prefix:String, shouldUpdatePosix:Bool? = false) -> String{
        
        let diffSecond = shouldUpdatePosix! ? "s": "second ago"
        let diffSeconds = shouldUpdatePosix! ? "s": "seconds ago"
        
        let diffMinute = shouldUpdatePosix! ? "m":"minute ago"
        let diffMinutes = shouldUpdatePosix! ? "m": "minutes ago"
        
        let diffHour = shouldUpdatePosix! ? "h":"hour ago"
        let diffHours = shouldUpdatePosix! ? "h":"hours ago"
        
        let diffDay = shouldUpdatePosix! ? "1d":"yesterday"
        let diff1Day = shouldUpdatePosix! ? "d": "day ago"
        let diffDays = shouldUpdatePosix! ? "d":"days ago"
        
        let diffMonth = shouldUpdatePosix! ? "mon":"month ago"
        let diffMonths = shouldUpdatePosix! ? "mon":"months ago"
        
        let diffyear = shouldUpdatePosix! ? "y":"year ago"
        let diffyears = shouldUpdatePosix! ? "y":"years ago"
        
        var endDate = Date()
        endDate = DateApp.getSystemTimeZoneDateFromUTCdate(UTCdate:endDate)!
        
        let calendar: Calendar = Calendar.current
        
        let calendarUnits:NSCalendar.Unit = [NSCalendar.Unit.month,NSCalendar.Unit.day, NSCalendar.Unit.hour,NSCalendar.Unit.minute, NSCalendar.Unit.second,NSCalendar.Unit.year]
        let dateComponents = (calendar as NSCalendar).components(calendarUnits, from:startDate, to: endDate, options: [])
        
        let hours:Int = abs(dateComponents.hour!)
        let min       = abs(dateComponents.minute!)
        let sec       = abs(dateComponents.second!)
        let days      = abs(dateComponents.day!)
        let months    = abs(dateComponents.month!)
        let years     = abs(dateComponents.year!)
        
        
        var timeAgo = ""
        
        if (sec > 0){
            timeAgo = "\(prefix)\(sec) \(((sec > 1) ? diffSeconds : diffSecond))"
        }
        
        if (min > 0){
            timeAgo = "\(prefix)\(min) \(((min > 1) ? diffMinutes : diffMinute))"
        }
        
        if (hours > 0){
            timeAgo = "\(prefix)\(hours) \(((hours > 1) ? diffHours : diffHour))"
        }
        
        if (days > 0){
            if (sec > 1) {
                if days > 1 {
                    timeAgo = "\(prefix)\(days) \(diffDays)"
                }else{
                    timeAgo = "\(prefix)\(days) \(diff1Day)"
                }
            }else{
                timeAgo = "\(prefix) \(diffDay)"
            }
        }
        
        if (months > 0){
            timeAgo = "\(prefix)\(months) \(((months > 1) ? diffMonths : diffMonth))"
        }
        
        if (years > 0){
            timeAgo = "\(prefix)\(years) \(((years > 1) ? diffyears : diffyear))"
        }
        
        return timeAgo
        
    }
    
    static func convertDateFormate(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let _ = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMMM"
        //        let newDate = DateApp.stringWithLocalTime(fromDate: date, withFormat: .fullMonth)
        let newDate = DateApp.string(fromDate: date, withFormat: .fullMonth)
        //dateFormate.string(from: date)
        
        //        var day  = "\(anchorComponents.day!)"
        var day = DateApp.string(fromDate: date, withFormat: .todayDateSingle)
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }
    
    static func convertDateFormateWithYear(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMMM"
        //        let newDate = DateApp.stringWithLocalTime(fromDate: date, withFormat: .fullMonth)
        let newDate = DateApp.string(fromDate: date, withFormat: .fullMonth)
        //dateFormate.string(from: date)
        
        //        var day  = "\(anchorComponents.day!)"
        var day = DateApp.string(fromDate: date, withFormat: .todayDateSingle)
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        let year = "\(anchorComponents.year!)".dropFirst(2)
        return newDate + " " + day + " '" + year
    }
    
    static func checkSameDate(date1 : Date, date2 : Date) -> Bool {
        let date1String = DateApp.string(fromDate: date1, withFormat: .activityServerDate)
        let date2String = DateApp.string(fromDate: date2, withFormat: .activityServerDate)
        let date1StringDate = DateApp.date(fromString: date1String, withFormat: .activityServerDate)
        let date2StringDate = DateApp.date(fromString: date2String, withFormat: .activityServerDate)
        
        let calendar = Calendar.current
        let startdateComponents = calendar.dateComponents([.day, .month, .year], from: date1StringDate!)
        var startComponent = DateComponents()
        startComponent.year = startdateComponents.year
        startComponent.month = startdateComponents.month
        startComponent.day = startdateComponents.day
        let startDate = calendar.date(from: startComponent)
        
        let endDateComponents = calendar.dateComponents([.day, .month, .year], from: date2StringDate!)
        var endComponent = DateComponents()
        endComponent.year = endDateComponents.year
        endComponent.month = endDateComponents.month
        endComponent.day = endDateComponents.day
        let endDate = calendar.date(from: endComponent)
        print(startDate!, endDate!)
        if ((startDate!.isSameDate(endDate!))) {
            return true
        }
        return false
    }
    
}

extension Date {
    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }
    
    func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedAscending
    }
    
    func isAfterDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
    func isSameYear(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .year)
        return order == .orderedSame
    }
    
    //    func startOfMonth() -> Date {
    //        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    //    }
    //    func endOfMonth() -> Date {
    //        return Calendar.current.date(byAdding: DateComponents(month: 1, day: 0), to: self.startOfMonth())!
    //    }
    
    
    func roundDateByMinutes(minuteInterval : Int) -> Date {
        let calendar = Calendar.current
        let nextDiff = minuteInterval - calendar.component(.minute, from: self) % minuteInterval
        return nextDiff != minuteInterval ? calendar.date(byAdding: .minute, value: nextDiff, to: self) ?? Date() : self
    }
    
}
extension Date{
    func getRelativeString() -> String{
        if #available(iOS 13.0, *) {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return formatter.localizedString(for: self, relativeTo: Date())
        } else {
            return relativePast(for: self)
            //return DateApp.string(fromDate: self, withFormat: .feed)
        }
        
    }
    
    func relativePast(for date : Date) -> String {
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: date, to: Date())
        
        if components.year! > 0 {
            return "\(components.year!) " + (components.year! > 1 ? "years ago" : "year ago")
            
        } else if components.month! > 0 {
            return "\(components.month!) " + (components.month! > 1 ? "months ago" : "month ago")
            
        } else if components.weekOfYear! > 0 {
            return "\(components.weekOfYear!) " + (components.weekOfYear! > 1 ? "weeks ago" : "week ago")
            
        } else if (components.day! > 0) {
            return (components.day! > 1 ? "\(components.day!) days ago" : "Yesterday")
            
        } else if components.hour! > 0 {
            return "\(components.hour!) " + (components.hour! > 1 ? "hours ago" : "hour ago")
            
        } else if components.minute! > 0 {
            return "\(components.minute!) " + (components.minute! > 1 ? "minutes ago" : "minute ago")
            
        } else {
            return "\(components.second!) " + (components.second! > 5 ? "seconds ago" : "Just Now".replacingOccurrences(of: "0", with: ""))
        }
    }
    
    func nextDay() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(-1, for: .day) // -1 day
        
        let now = self
        let yesterday = Calendar.current.date(byAdding: dateComponents, to: now) // Add the DateComponents
        
        return yesterday!
    }
    
    func previousDay() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day); // +1 day
        
        let now = self// Current date
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: now)  // Add the DateComponents
        
        return tomorrow!
    }
}
