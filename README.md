# SwiftLocalNotification
#### Easy to use, Easy to push local notification in swift.
<img src="https://github.com/Salarsoleimani/SwiftLocalNotification/blob/master/SwiftLocalNotificationHeader.png" class="center">

[![CI Status](https://img.shields.io/travis/salarsoleimani/SwiftLocalNotification.svg?style=flat)](https://travis-ci.org/salarsoleimani/SwiftLocalNotification)
[![Version](https://img.shields.io/cocoapods/v/SwiftLocalNotification.svg?style=flat)](https://cocoapods.org/pods/SwiftLocalNotification)
[![License](https://img.shields.io/cocoapods/l/SwiftLocalNotification.svg?style=flat)](https://cocoapods.org/pods/SwiftLocalNotification)
[![Platform](https://img.shields.io/cocoapods/p/SwiftLocalNotification.svg?style=flat)](https://cocoapods.org/pods/SwiftLocalNotification)
## Installation
SwiftLocalNotification is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:
```ruby
pod 'SwiftLocalNotification'
```
## Demo
<img src="https://github.com/Salarsoleimani/SwiftLocalNotification/blob/master/Screenshot.jpeg" height="600">

## Usage example

```swift
// set the delegate to get the UNUserNotificationCenter delegates
let scheduler = SwiftLocalNotification(delegate: self) 

// you can set the identifier to empty and it will generate a random UUID 
let sampleNotification = SwiftLocalNotificationModel(title: "sampleTitle", body: "sampleBody", subtitle: nil, date: Date().next(seconds: 5), repeating: .none, identifier: "", soundName: nil, badge: 5)

// you can add the action button for your notification by easy 3 steps, but always remember do it before scheduling notification
let snoozeAction = UNNotificationAction(identifier: "snoozeAction", title: "Snooze in 2 minutes", options: [.authenticationRequired, .foreground])
let category = SwiftLocalNotificationCategory(categoryIdentifier: "snooze", actions: [snoozeAction])
category.set(forNotifications: sampleNotification)

// finally schedule the notification
scheduler.schedule(sampleNotification)
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usecases
Get the permission status of notification privacy and request for permission for push the notification.
```swift
var permissionStatus: PermissionStatus { get }
func requestPermission(completion: @escaping (PermissionStatus) -> Void)
```
Get all and specific scheduled or delivered notifications. get the quantity of scheduled notifications.
```swift
func getAllScheduledNotifications() -> [SwiftLocalNotificationModel]
func getAllDeliveredNotifications() -> [SwiftLocalNotificationModel]
func getScheduled(notificationId id: String) -> SwiftLocalNotificationModel?
func getDelivered(notificationId id: String) -> SwiftLocalNotificationModel?
func getScheduledNotificationsCount() -> Int
```
Schedule notification
```swift
func schedule(notification notif: SwiftLocalNotificationModel) -> String?
```
Edit the existing notification
```swift
func reSchedule(notification notif: SwiftLocalNotificationModel) -> String?
```
Schedule one daily notification from a specific time for example "08:00" to a specific time and determine to how many times user get the notification
```swift
func scheduleDaily(notifications notif: SwiftLocalNotificationModel, fromTime: Date, toTime: Date, howMany: Int) -> [String]?
```
Schedule set of notifications between two specific dates
```swift
func scheduleDaily(notifications notifs: [SwiftLocalNotificationModel], fromTime: Date, toTime: Date) -> [String]?
```
Schedule a notification between two specific dates by adding interval after from date
```swift
func schedule(notification notif: SwiftLocalNotificationModel, fromDate: Date, toDate: Date, interval: TimeInterval) -> String?
```
Simple push notification
```swift
func push(notification notif: SwiftLocalNotificationModel, secondsLater seconds: TimeInterval) -> String?)
```
Set the badge of application
```swift
func setApplicationBadge(_ option: BadgeOption, value: Int)
```
Cancel notifications
```swift
func cancelAllNotifications()
func cancel(notificationIds: String...)
```
## Author

#### | ["Follow @salarsoleimani Twitter"](http://twitter.com/salarsoleimani) |
#### | ["Email me"](mailto:s.s_m1983@yahoo.com) |

## License
SwiftLocalNotification is available under the MIT license. See the LICENSE file for more info.
