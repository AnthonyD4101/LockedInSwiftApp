//
//  ProfileView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Account Icon
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    // Welcome Message
                    if let username = userViewModel.currentUser?.username {
                        Text("Welcome, \(username)!")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .bold()
                            .padding(.top, 16)
                    } else {
                        Text("Welcome!")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .bold()
                            .padding(.top, 16)
                    }
                    
                    // MARK: - User Settings and App Statistics Buttons
                    VStack(spacing: 24) {
                        NavigationLink(destination: SettingsView()
                            .environmentObject(userViewModel)
                            .environmentObject(taskViewModel)
                        ) {
                            Text("User Settings")
                                .font(.system(size: 18))
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
                                                   startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(8)
                        }
                        
                        NavigationLink(destination: StatisticsView()
                            .environmentObject(userViewModel)
                            .environmentObject(taskViewModel)
                        ) {
                            Text("App Statistics")
                                .font(.system(size: 18))
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
                                                   startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top, 36)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    let userViewModel = UserViewModel()
    let taskViewModel = TaskViewModel()
    
    ProfileView()
        .environmentObject(userViewModel)
        .environmentObject(taskViewModel)
}
