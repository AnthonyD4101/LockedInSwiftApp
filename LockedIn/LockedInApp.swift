//
//  LockedInApp.swift
//  LockedIn
//
//  Created by Anthony Delgado on 9/27/24.
//

import SwiftUI
import Firebase

@main
struct LockedInApp: App {
    @StateObject private var dbUserViewModel = DBUserViewModel()
    @StateObject private var dbTaskViewModel = DBTaskViewModel()
    
    // Needed initialization for Firebase setup
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(dbUserViewModel)
                .environmentObject(dbTaskViewModel)
        }
    }
}
