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
                
                VStack {
                    // Account Icon
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    // Welcome Message
                    if let username = dbUserViewModel.currentUser?.username {
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
                    if isLandscape {
                        HStack(spacing: 24) {
                            NavigationLink(destination: SettingsView()
                                .environmentObject(dbUserViewModel)
                                .environmentObject(dbTaskViewModel)
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
                                .environmentObject(dbUserViewModel)
                                .environmentObject(dbTaskViewModel)
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
                    }
                    else{
                        VStack(spacing: 24) {
                            NavigationLink(destination: SettingsView()
                                .environmentObject(dbUserViewModel)
                                .environmentObject(dbTaskViewModel)
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
                                .environmentObject(dbUserViewModel)
                                .environmentObject(dbTaskViewModel)
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
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    let dbUserViewModel = DBUserViewModel()
    let dbTaskViewModel = DBTaskViewModel()

    // Mock user for preview
    dbUserViewModel.currentUser = DBUser(
        id: "testUserId",
        email: "test@example.com",
        username: "TestUser",
        password: "password123"
    )

    return ProfileView()
        .environmentObject(dbUserViewModel)
        .environmentObject(dbTaskViewModel)
}
