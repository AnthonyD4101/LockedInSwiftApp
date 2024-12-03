//
//  ContentView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 9/27/24.
//

import SwiftUI

struct ContentView: View {
    // TODO: Replace Old Models with DB Ones
    @StateObject var userViewModel = UserViewModel()
    @StateObject var taskViewModel = TaskViewModel()
    
    @StateObject var dbUserViewModel = DBUserViewModel()
    @StateObject var dbTaskViewModel = DBTaskViewModel()
    
    var body: some View {
        NavigationView {
            if dbUserViewModel.currentUser != nil {
                TabView {
                    TasksView(dbTaskViewModel: dbTaskViewModel, dbUserViewModel: dbUserViewModel)
                        .tabItem {
                            Label("Tasks", systemImage: "list.bullet")
                        }
                    
                    CalendarView(dbUserViewModel: dbUserViewModel, dbTaskViewModel: dbTaskViewModel)
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
                        }
                    
                    FocusView()
                        .tabItem {
                            Label("Focus", systemImage: "clock")
                        }
                    
                    // TODO: Eventually Use DB Models Here
                    CommunityView(taskViewModel: taskViewModel)
                        .tabItem {
                            Label("Community", systemImage: "person.3")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                        .environmentObject(dbTaskViewModel)
                }
            } else {
                SignInView(isSignedIn: Binding(
                    get: { dbUserViewModel.currentUser != nil },
                    set: { if !$0 { dbUserViewModel.logOut() } }
                ))
            }
        }
        .preferredColorScheme(.dark)
        .environmentObject(dbUserViewModel)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dbUserViewModel = DBUserViewModel()
        let dbTaskViewModel = DBTaskViewModel()
        
        ContentView()
            .environmentObject(dbUserViewModel)
            .environmentObject(dbTaskViewModel)
    }
}

// MARK: OLD DATA MODEL IMPLEMENTATION
//struct ContentView: View {
//    @StateObject var userViewModel = UserViewModel()
//    @StateObject var taskViewModel = TaskViewModel()
//    
//    var body: some View {
//        NavigationView {
//            if userViewModel.currentUser != nil {
//                TabView {
//                    TasksView(taskViewModel: taskViewModel)
//                        .tabItem {
//                            Label("Tasks", systemImage: "list.bullet")
//                        }
//                    
//                    CalendarView(taskViewModel: taskViewModel)
//                        .tabItem {
//                            Label("Calendar", systemImage: "calendar")
//                        }
//                    
//                    FocusView()
//                        .tabItem {
//                            Label("Focus", systemImage: "clock")
//                        }
//                    
//                    CommunityView(taskViewModel: taskViewModel)
//                        .tabItem {
//                            Label("Community", systemImage: "person.3")
//                        }
//                    
//                    ProfileView()
//                        .tabItem {
//                            Label("Profile", systemImage: "person")
//                        }
//                        .environmentObject(taskViewModel)
//                }
//            } else {
//                SignInView(isSignedIn: Binding(
//                    get: { userViewModel.currentUser != nil },
//                    set: { if !$0 { userViewModel.logOut() } }
//                ))
//            }
//        }
//        .preferredColorScheme(.dark)
//        .environmentObject(userViewModel)
//    }
//}
//
//// MARK: - Preview
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let userViewModel = UserViewModel()
//        let taskViewModel = TaskViewModel()
//        
//        ContentView()
//            .environmentObject(userViewModel)
//            .environmentObject(taskViewModel)
//    }
//}
