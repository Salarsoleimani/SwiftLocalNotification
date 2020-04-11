//
//  SwiftLocalNotificationQueue.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-10.
//  Copyright © 2020 Salar Soleimani. All rights reserved.
//

import Foundation

private class SwiftLocalNotificationQueue : NSObject {
  fileprivate var notifQueue = [SwiftLocalNotificationModel]()
  static let queue = SwiftLocalNotificationQueue()
  let ArchiveURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("notifications.swiftLocalNotificationQueue")
  
  override init() {
    super.init()
    if let notificationQueue = self.load() {
      notifQueue = notificationQueue
    }
  }
  
  ///- paramater notification SwiftLocalNotificationModel to push.
  fileprivate func push(_ notification: SwiftLocalNotificationModel) {
    notifQueue.insert(notification, at: findInsertionPoint(notification))
  }
  
  /// Finds the position at which the new SwiftLocalNotificationModel is inserted in the queue.
  /// - parameter notification: SwiftLocalNotificationModel to insert.
  /// - returns: Index to insert the SwiftLocalNotificationModel at.
  /// - seealso: [swift-algorithm-club](https://github.com/hollance/swift-algorithm-club/tree/master/Ordered%20Array)
  fileprivate func findInsertionPoint(_ notification: SwiftLocalNotificationModel) -> Int {
    let range = 0..<notifQueue.count
    var rangeLowerBound = range.lowerBound
    var rangeUpperBound = range.upperBound
    
    while rangeLowerBound < rangeUpperBound {
      let midIndex = rangeLowerBound + (rangeUpperBound - rangeLowerBound) / 2
      if notifQueue[midIndex] == notification {
        return midIndex
      } else if notifQueue[midIndex] < notification {
        rangeLowerBound = midIndex + 1
      } else {
        rangeUpperBound = midIndex
      }
    }
    return rangeLowerBound
  }
  
  ///Removes and returns the head of the queue.
  ///- returns: The head of the queue.
  fileprivate func pop() -> SwiftLocalNotificationModel {
    return notifQueue.removeFirst()
  }
  
  ///- returns: The head of the queue.
  fileprivate func peek() -> SwiftLocalNotificationModel? {
    return notifQueue.last
  }
  
  ///Clears the queue.
  fileprivate func clear() {
    notifQueue.removeAll()
  }
  
  ///Called when an SwiftLocalNotificationModel is cancelled.
  ///- parameter index: Index of SwiftLocalNotificationModel to remove.
  fileprivate func removeAtIndex(_ index: Int) {
    notifQueue.remove(at: index)
  }
  
  ///- returns: Count of SwiftLocalNotificationModel in the queue.
  fileprivate func count() -> Int {
    return notifQueue.count
  }
  
  ///- returns: The notifications queue.
  fileprivate func notificationsQueue() -> [SwiftLocalNotificationModel] {
    let queue = notifQueue
    return queue
  }
  
  ///- parameter identifier: Identifier of the notification to return.
  ///- returns: SwiftLocalNotificationModel if found, nil otherwise.
  fileprivate func notificationWithIdentifier(_ identifier: String) -> SwiftLocalNotificationModel? {
    for note in notifQueue {
      if note.identifier == identifier {
        return note
      }
    }
    return nil
  }
  
  // MARK: NSCoding
  
  ///Save queue on disk.
  ///- returns: The success of the saving operation.
  fileprivate func save() -> Bool {
    return NSKeyedArchiver.archiveRootObject(self.notifQueue, toFile: ArchiveURL.path)
  }
  
  ///Load queue from disk.
  ///Called first when instantiating the SwiftLocalNotificationQueue singleton.
  ///You do not need to manually call this method and therefore do not declare it as public.
  fileprivate func load() -> [SwiftLocalNotificationModel]? {
    return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [SwiftLocalNotificationModel]
  }
  
}
