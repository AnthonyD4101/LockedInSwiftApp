//
//  ContentView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 9/27/24.
//

import SwiftUI

// MARK: - Content View
struct ContentView: View {
    @State private var isSignedIn: Bool = false
    
    var body: some View {
        NavigationView {
            if isSignedIn {
                TabView {
                    TasksView()
                        .tabItem {
                            Label("Tasks", systemImage: "list.bullet")
                        }
                    
                    CalendarView()
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
                        }
                    
                    FocusView()
                        .tabItem {
                            Label("Focus", systemImage: "clock")
                        }
                    
                    CommunityView()
                        .tabItem {
                            Label("Community", systemImage: "person.3")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                }
                .onAppear {
                    isSignedIn = true
                }
            } else {
                SignInView(isSignedIn: $isSignedIn)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
