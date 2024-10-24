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
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Account Icon
                Image(systemName: "person.circle.fill")
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
                
                Spacer()
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
