//
// Copyright 2014 Scott Logic
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import UIKit

let restartTimerActionString = "RestartTimer"
let editTimerActionString = "EditTimer"
let snoozeTimerActionString = "SnoozeTimer"
let timerFiredCategoryString = "TimerFiredCategory"


protocol TimerNotificationManagerDelegate {
  func timerStatusChanged()
}

class TimerNotificationManager: Printable {
  var delegate: TimerNotificationManagerDelegate?
  
  var timerRunning: Bool {
    didSet {
      delegate?.timerStatusChanged()
    }
  }
  
  var timerDuration: Float {
    didSet {
      delegate?.timerStatusChanged()
    }
  }
  
  var description: String {
    return "Timer Duration: \(timerDuration). Currently Running: \(timerRunning)"
  }

  init() {
    timerRunning = false
    timerDuration = 30.0
    registerForNotifications()
    checkForPreExistingTimer()
  }
  
  func startTimer() {
    if !timerRunning {
      // Create the notification...
      let timer = createTimer()
      UIApplication.sharedApplication().scheduleLocalNotification(timer)
      timerRunning = true
    }
  }
  
  func stopTimer() {
    if timerRunning {
      // Kill all local notifications
      UIApplication.sharedApplication().cancelAllLocalNotifications()
      timerRunning = false
    }
  }
  
  func restartTimer() {
    if timerRunning {
      stopTimer()
      startTimer()
    }
  }
  
  // MARK: - Utility methods
  private func checkForPreExistingTimer() {
    if UIApplication.sharedApplication().scheduledLocalNotifications.count > 0 {
      timerRunning = true
    }
  }

  private func createTimer() -> UILocalNotification {
    let notification = UILocalNotification()
    notification.category = timerFiredCategoryString
    notification.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(timerDuration))
    notification.alertBody = "Your time is up!"
    return notification
  }
  
  private func registerForNotifications() {
    let requestedTypes = UIUserNotificationType.Alert | .Sound
    let categories = NSSet(object: timerFiredNotificationCategory())
    let settingsRequest = UIUserNotificationSettings(forTypes: requestedTypes, categories: categories)
    UIApplication.sharedApplication().registerUserNotificationSettings(settingsRequest)
  }
  
  private func timerFiredNotificationCategory() -> UIUserNotificationCategory {
    let restartAction = UIMutableUserNotificationAction()
    restartAction.identifier = restartTimerActionString
    restartAction.destructive = false
    restartAction.title = "Restart"
    restartAction.activationMode = .Background
    restartAction.authenticationRequired = false
    
    let editAction = UIMutableUserNotificationAction()
    editAction.identifier = editTimerActionString
    editAction.destructive = true
    editAction.title = "Edit"
    editAction.activationMode = .Foreground
    editAction.authenticationRequired = true
    
    let snoozeAction = UIMutableUserNotificationAction()
    snoozeAction.identifier = snoozeTimerActionString
    snoozeAction.destructive = false
    snoozeAction.title = "Snooze"
    snoozeAction.activationMode = .Background
    snoozeAction.authenticationRequired = false
    
    let category = UIMutableUserNotificationCategory()
    category.identifier = timerFiredCategoryString
    category.setActions([restartAction, snoozeAction], forContext: .Minimal)
    category.setActions([restartAction, snoozeAction, editAction], forContext: .Default)
    
    return category
  }
}
