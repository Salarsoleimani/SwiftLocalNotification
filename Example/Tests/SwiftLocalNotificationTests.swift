//
//  SwiftLocalNotificationTests.swift
//  SwiftLocalNotification_Tests
//
//  Created by Salar Soleimani on 2020-04-11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftLocalNotification

class SwiftLocalNotificationTests: XCTestCase {
  var notificationScheduler: SwiftLocalNotification?
  var sampleNotification1: SwiftLocalNotificationModel?
  var sampleNotification2: SwiftLocalNotificationModel?
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    notificationScheduler = SwiftLocalNotification()
    sampleNotification1 = SwiftLocalNotificationModel(title: "Hi1", body: "This is test1", date: Date().addingTimeInterval(1), repeating: .none)
    sampleNotification2 = SwiftLocalNotificationModel(title: "Hi2", body: "This is test1", date: Date().next(hours: 1), repeating: .none)
    notificationScheduler?.cancelAllNotifications()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    sampleNotification2 = nil
    sampleNotification1 = nil
    notificationScheduler?.cancelAllNotifications()
    notificationScheduler = nil
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testApplicationBadge() {
    notificationScheduler?.setApplicationBadge(.reset, value: 1)
    XCTAssertEqual(UIApplication.shared.applicationIconBadgeNumber, 0)
    
    notificationScheduler?.setApplicationBadge(.increase, value: 1)
    XCTAssertEqual(UIApplication.shared.applicationIconBadgeNumber, 1)
    
    notificationScheduler?.setApplicationBadge(.decrease, value: 1)
    XCTAssertEqual(UIApplication.shared.applicationIconBadgeNumber, 0)
  }
  
  
  func testScheduleNotification() {
    let notifId = notificationScheduler?.schedule(notification: sampleNotification1!)
    let notifCount = notificationScheduler?.getScheduledNotificationsCount()
    XCTAssertNotNil(notifId)
    XCTAssertEqual(1, notifCount)
  }
  
  func testCancelAllNotifications() {
    let _ = notificationScheduler?.schedule(notification: sampleNotification1!)
    let notifCount = notificationScheduler?.getScheduledNotificationsCount()
    XCTAssertEqual(1, notifCount)
    notificationScheduler?.cancelAllNotifications()
    let newNotifCount = notificationScheduler?.getScheduledNotificationsCount()
    XCTAssertEqual(0, newNotifCount)
  }
  
  func testCancelNotification() {
    let notifId = notificationScheduler?.schedule(notification: sampleNotification1!)
    let notifCount = notificationScheduler?.getScheduledNotificationsCount()
    XCTAssertEqual(1, notifCount)
    notificationScheduler?.cancel(notificationIds: notifId!)
    let newNotifCount = notificationScheduler?.getScheduledNotificationsCount()
    XCTAssertEqual(0, newNotifCount)
  }
  
  func testScheduleDailyNotification() {
    let notifIds = notificationScheduler?.scheduleDaily(notifications: sampleNotification1!, fromTime: Date(), toTime: Date().addingTimeInterval(300), howMany: 5)
    XCTAssertEqual(notifIds!.count, 5)
    let notifCount = notificationScheduler?.getScheduledNotificationsCount()
    XCTAssertEqual(notifCount, 1)
  }
  
  func testGetAllScheduledNotifications() {
    let _ = notificationScheduler?.schedule(notification: sampleNotification1!)
    let _ = notificationScheduler?.schedule(notification: sampleNotification2!)
    let allNotifs = notificationScheduler?.getAllScheduledNotifications()
    XCTAssertEqual(allNotifs!.count, 2)
  }
  func testGetScheduledNotification() {
    let notifId = notificationScheduler?.schedule(notification: sampleNotification1!)
    let scheduledNotif = notificationScheduler?.getScheduled(notificationId: notifId!)
    XCTAssertEqual(scheduledNotif?.identifier, notifId)
  }
  
  func testGetAllDeliveredNotification() {
    var notifId: String?
    let expectationTemp = expectation(description: "Get all delivered notification")
    let responseClousure: (UNNotificationResponse) -> Void = { response in
      print(response)
    }
    let notifClousure: (UNNotification) -> Void = { notif in
      XCTAssertEqual(notif.request.identifier, notifId)
      expectationTemp.fulfill()
    }
    
    let notifScheduler = SwiftLocalNotification(didRecieveResponse: responseClousure, didRecieveNotificationInApp: notifClousure)
    notifScheduler.cancelAllNotifications()
    let sampleNotification3 = SwiftLocalNotificationModel(title: "Hi1", body: "This is test1", date: Date().addingTimeInterval(1), repeating: .none)
    notifId = notifScheduler.schedule(notification: sampleNotification3)
    waitForExpectations(timeout: 3, handler: nil)
  }
}
