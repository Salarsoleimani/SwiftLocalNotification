# SwiftLocalNotification
##### Easy to use, Easy to push local notification in swift.<img src="https://github.com/Salarsoleimani/SwiftLocalNotification/blob/master/SwiftLocalNotificationHeader.png">
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

```swift
// get the permission status of notification privacy
var permissionStatus: PermissionStatus { get }
// request for permission for push the notification
func requestPermission(completion: @escaping (PermissionStatus) -> Void)

func getAllScheduledNotifications() -> [SwiftLocalNotificationModel]
func getAllDeliveredNotifications() -> [SwiftLocalNotificationModel]
func getScheduled(notificationId id: String) -> SwiftLocalNotificationModel?
func getDelivered(notificationId id: String) -> SwiftLocalNotificationModel?
func getScheduledNotificationsCount() -> Int

func schedule(notification notif: SwiftLocalNotificationModel) -> String?
// edit the existing notification
func reSchedule(notification notif: SwiftLocalNotificationModel) -> String?
// schedule one daily notification from a specific time for example "08:00" to a specific time and determine to how many times user get the notification
func scheduleDaily(notifications notif: SwiftLocalNotificationModel, fromTime: Date, toTime: Date, howMany: Int) -> [String]?
// schedule set of notifications between two specific dates
func scheduleDaily(notifications notifs: [SwiftLocalNotificationModel], fromTime: Date, toTime: Date) -> [String]?
// schedule a notification between two specific dates by adding interval after from date
func schedule(notification notif: SwiftLocalNotificationModel, fromDate: Date, toDate: Date, interval: TimeInterval) -> String?
// simple push notification
func push(notification notif: SwiftLocalNotificationModel, secondsLater seconds: TimeInterval) -> String?)
// set the badge of application
func setApplicationBadge(_ option: BadgeOption, value: Int)
    
func cancelAllNotifications()
func cancel(notificationIds: String...)
func cancel(notificationIds: [String])
```
## Author

#### | ["Follow @salarsoleimani Twitter"](http://twitter.com/salarsoleimani) |
#### | ["Email me"](mailto:s.s_m1983@yahoo.com) |

## License
SwiftLocalNotification is available under the MIT license. See the LICENSE file for more info.
