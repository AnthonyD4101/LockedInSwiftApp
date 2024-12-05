//
//  ProfileView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dbUserViewModel: DBUserViewModel
    @EnvironmentObject var dbTaskViewModel: DBTaskViewModel
    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass
    
    @State private var showSignOutAlert: Bool = false
    
    var body: some View {
        let orientation = DeviceOrientation(
            widthSizeClass: widthSizeClass,
            heightSizeClass: heightSizeClass
        )
        
        let isLandscape = orientation.isLandscape(device: .iPhonePlusOrMax) || orientation.isLandscape(device: .iPhone) || orientation.isLandscape(device: .iPadFull)
        
        NavigationView {
            ZStack {
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                if isLandscape {
                    HStack(spacing: 24) {
                        // Left Side: User Info
                        VStack {
                            HStack(alignment: .center, spacing: 12) {
                                if let username = dbUserViewModel.currentUser?.username {
                                    Text("Welcome, \(username)!")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                        .bold()
                                } else {
                                    Text("Welcome!")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                        .bold()
                                }
                                
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 40)
                            
                            
                            HStack(spacing: 16) {
                                NavigationLink(destination: SettingsView()
                                    .environmentObject(dbUserViewModel)
                                    .environmentObject(dbTaskViewModel)
                                ) {
                                    Text("User Settings")
                                        .font(.system(size: 18))
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
                                                           startPoint: .leading, endPoint: .trailing)
                                        )
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    showSignOutAlert = true
                                }) {
                                    Text("Sign Out")
                                        .font(.system(size: 18))
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [.red, .orange]),
                                                           startPoint: .leading, endPoint: .trailing)
                                        )
                                        .cornerRadius(8)
                                }
                                .alert(isPresented: $showSignOutAlert) {
                                    Alert(
                                        title: Text("Sign Out"),
                                        message: Text("Are you sure you want to sign out?"),
                                        primaryButton: .destructive(Text("Sign Out")) {
                                            dbUserViewModel.logOut()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                            .padding(.bottom, 20)

                        }
                        .frame(maxWidth: .infinity)
                        
                        // Right Side: Embedded Statistics
                        VStack(alignment: .leading, spacing: 16) {
                            Text("App Statistics")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 24)
                            
                            StatisticRow(title: "Total Tasks", value: "\(dbUserViewModel.currentUser?.statistics.totalTasks ?? 0)")
                            StatisticRow(title: "Completed Tasks", value: "\(dbUserViewModel.currentUser?.statistics.completedTasks ?? 0)")
                            StatisticRow(title: "Total Subtasks", value: "\(dbUserViewModel.currentUser?.statistics.totalSubtasks ?? 0)")
                            StatisticRow(title: "Completed Subtasks", value: "\(dbUserViewModel.currentUser?.statistics.completedSubtasks ?? 0)")
                            
                            Spacer()
                                .frame(height: 50)
                            
                                                    }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    ScrollView {
                        VStack {
                            HStack(alignment: .center, spacing: 12) {
                                if let username = dbUserViewModel.currentUser?.username {
                                    Text("Welcome, \(username)!")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                        .bold()
                                } else {
                                    Text("Welcome!")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                        .bold()
                                }
                                
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 40)
                            
                            // Embedded Statistics Section
                            VStack(spacing: 16) {
                                Image(systemName: "chart.bar.xaxis")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.orange)
                                    .padding(.top, 40)
                                
                                Text("App statistics locked in, just for you!")
                                    .foregroundColor(.white)
                                    .font(.system(size: 28))
                                    .bold()
                                    .padding(.top, 16)
                                    .multilineTextAlignment(.center)
                                
                                StatisticRow(title: "Total Tasks", value: "\(dbUserViewModel.currentUser?.statistics.totalTasks ?? 0)")
                                StatisticRow(title: "Completed Tasks", value: "\(dbUserViewModel.currentUser?.statistics.completedTasks ?? 0)")
                                StatisticRow(title: "Total Subtasks", value: "\(dbUserViewModel.currentUser?.statistics.totalSubtasks ?? 0)")
                                StatisticRow(title: "Completed Subtasks", value: "\(dbUserViewModel.currentUser?.statistics.completedSubtasks ?? 0)")
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 60)
                            
                            HStack(spacing: 16) {
                                // User Settings
                                NavigationLink(destination: SettingsView()
                                    .environmentObject(dbUserViewModel)
                                    .environmentObject(dbTaskViewModel)
                                ) {
                                    Text("User Settings")
                                        .font(.system(size: 18))
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
                                                           startPoint: .leading, endPoint: .trailing)
                                        )
                                        .cornerRadius(8)
                                }
                                
                                // Sign Out Button
                                Button(action: {
                                    showSignOutAlert = true
                                }) {
                                    Text("Sign Out")
                                        .font(.system(size: 18))
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [.red, .orange]),
                                                           startPoint: .leading, endPoint: .trailing)
                                        )
                                        .cornerRadius(8)
                                }
                                .alert(isPresented: $showSignOutAlert) {
                                    Alert(
                                        title: Text("Sign Out"),
                                        message: Text("Are you sure you want to sign out?"),
                                        primaryButton: .destructive(Text("Sign Out")) {
                                            dbUserViewModel.logOut()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await dbUserViewModel.refreshStatistics()
            }
        }
    }
}
