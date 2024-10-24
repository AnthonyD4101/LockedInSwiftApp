//
//  ContentView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 9/27/24.
//

import SwiftUI

// MARK: - Content View
struct ContentView: View {
    @StateObject var taskViewModel = TaskViewModel()
    @State private var isSignedIn: Bool = false
    
    var body: some View {
        NavigationView {
            if isSignedIn {
                TabView {
                    TasksView(taskViewModel: taskViewModel)
                        .tabItem {
                            Label("Tasks", systemImage: "list.bullet")
                        }
                    
                    CalendarView(taskViewModel: taskViewModel)
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
