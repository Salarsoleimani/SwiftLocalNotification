//
//  DateExtensions.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-01.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import Foundation

extension Date {
  func convertToDateComponent(repeatInterval: RepeatingInterval) -> DateComponents {
    switch repeatInterval {
    case .none:
      return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second ], from: self)
    case .minute:
      return Calendar.current.dateComponents([.second], from: self)
    case .hourly:
      return Calendar.current.dateComponents([.minute], from: self)
    case .daily:
      return Calendar.current.dateComponents([.hour, .minute], from: self)
    case .weekly:
      return Calendar.current.dateComponents([.hour, .minute, .weekday], from: self)
    case .monthly:
      return Calendar.current.dateComponents([.hour, .minute, .day], from: self)
    case .yearly:
      return Calendar.current.dateComponents([.hour, .minute, .day, .month], from: self)
    }
  }
}

public extension Date {
  
  /// Adds a number of seconds to a date.
  /// > This method can add and subtract minutes.
  ///
  /// - Parameter seconds: The number of minutes to add/subtract.
  /// - Returns: The date after the seconds addition/subtraction.
  func next(seconds: TimeInterval) -> Date {
    return self.addingTimeInterval(seconds)
  }
  
  /// Adds a number of minutes to a date.
  /// > This method can add and subtract minutes.
  ///
  /// - Parameter minutes: The number of minutes to add/subtract.
  /// - Returns: The date after the minutes addition/subtraction.
  func next(minutes: Int) -> Date {
    let calendar = Calendar.current
    var components = DateComponents()
    components.minute = minutes
    return (calendar as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options(rawValue: 0))!
  }
  
  /// Adds a number of hours to a date.
  /// > This method can add and subtract hours.
  ///
  /// - Parameter hours: The number of hours to add/subtract.
  /// - Returns: The date after the hours addition/subtraction.
  func next(hours: Int) -> Date {
    return self.next(minutes: hours * 60)
  }
  
  /// Adds a number of days to a date.
  /// >This method can add and subtract days.
  ///
  /// - Parameter days: The number of days to add/subtract.
  /// - Returns: The date after the days addition/subtraction.
  func next(days: Int) -> Date {
    return self.next(minutes: days * 60 * 24)
  }
  
  /// Removes the seconds component from the date.
  ///
  /// - Returns: The date after removing the seconds component.
  func removeSeconds() -> Date {
    let calendar = Calendar.current
    let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: self)
    return calendar.date(from: components)!
  }
  
  /// Creates a date object with the given time and offset. The offset is used to align the time with the GMT.
  ///
  /// - Parameters:
  ///   - time: The required time of the form HHMM.
  ///   - offset: The offset in minutes.
  /// - Returns: Date with the specified time and offset.
  static func date(withTime time: Int, offset: Int) -> Date {
    let calendar = Calendar.current
    var components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: Date())
    components.minute = (time % 100) + offset % 60
    components.hour = (time / 100) + (offset / 60)
    var date = calendar.date(from: components)!
    if date < Date() {
      date = date.next(days: 1)
    }
    
    return date
  }
}
