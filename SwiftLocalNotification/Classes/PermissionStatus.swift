//
//  PermissionStatus.swift
//  SwiftLocalNotification
//
//  Created by Salar Soleimani on 2020-04-01.
//  Copyright © 2020 SaSApps.ca All rights reserved.
//

import Foundation

public enum PermissionStatus: String {
  case authorized    = "Authorized"
  case denied        = "Denied"
  case disabled      = "Disabled"
  case notDetermined = "Not Determined"
  
  init?(string: String?) {
    guard let string = string else { return nil }
    self.init(rawValue: string)
  }
}

extension PermissionStatus: CustomStringConvertible {
  /// The textual representation of self.
  public var description: String {
    return rawValue
  }
}
