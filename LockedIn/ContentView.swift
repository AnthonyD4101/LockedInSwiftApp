//
//  ContentView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 9/27/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userViewModel = UserViewModel()
    @StateObject var taskViewModel = TaskViewModel()
    
    var body: some View {
        NavigationView {
            if userViewModel.currentUser != nil {
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
                    
                    CommunityView(taskViewModel: taskViewModel)
                        .tabItem {
                            Label("Community", systemImage: "person.3")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                }
            } else {
                SignInView(isSignedIn: Binding(
                    get: { userViewModel.currentUser != nil },
                    set: { if !$0 { userViewModel.logOut() } }
                ))
            }
        }
        .preferredColorScheme(.dark)
        .environmentObject(userViewModel)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        
        ContentView()
            .environmentObject(userViewModel)
    }
}
