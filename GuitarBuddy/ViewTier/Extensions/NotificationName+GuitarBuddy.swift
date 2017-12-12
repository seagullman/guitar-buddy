//
//  NotificationName+GuitarBuddy.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/6/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation


extension Notification.Name {
    
    static let startLaunchFlow = Notification.Name("GuitarBuddyLaunch")
    static let showAuthenticatedFlow = Notification.Name("ShowAuthenticatedFlow")
    static let showSetupFlow = Notification.Name("ShowSetupFlow")
    static let signOut = Notification.Name("SignOut")
}
