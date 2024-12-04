//
//  SettingsView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/24/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dbUserViewModel: DBUserViewModel
    
    @State private var newEmail: String = ""
    @State private var newUsername: String = ""
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPasswordChangeAlert: Bool = false
    @State private var showInfoChangeAlert: Bool = false
    @State private var passwordChangeMessage: String = ""
    @State private var infoChangeMessage: String = ""
    
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.system(size: 24))
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Email Change
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Change Email")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .bold()
                            .padding(.leading, 40)
                        
                        TextField("New Email", text: $newEmail)
                            .padding()
                            .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                    }
                    
                    // Username Change
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Change Username")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .bold()
                            .padding(.leading, 40)
                        
                        TextField("New Username", text: $newUsername)
                            .padding()
                            .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                    }
                    
                    // Save Changes Button
                    Button(action: {
                        Task {
                            if !newEmail.isEmpty {
                                await dbUserViewModel.updateEmail(newEmail: newEmail)
                                infoChangeMessage += "Email updated successfully.\n"
                            }
                            if !newUsername.isEmpty {
                                await dbUserViewModel.updateUsername(newUsername: newUsername)
                                infoChangeMessage += "Username updated successfully."
                            }
                            showInfoChangeAlert = true
                        }
                    }) {
                        Text("Save Changes")
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
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .alert(isPresented: $showInfoChangeAlert) {
                        Alert(title: Text("Changes Saved"), message: Text(infoChangeMessage), dismissButton: .default(Text("OK")))
                    }
                }
                
                Divider()
                    .background(Color.white)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                
                // Form for updating password
                VStack(alignment: .leading, spacing: 16) {
                    Text("Change Password")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                        .padding(.leading, 40)
                    
                    SecureField("New Password", text: $newPassword)
                        .padding()
                        .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                    
                    SecureField("Confirm New Password", text: $confirmPassword)
                        .padding()
                        .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                    
                    // Change Password Button
                    Button(action: {
                        Task {
                            if newPassword == confirmPassword {
                                await dbUserViewModel.updatePassword(newPassword: newPassword)
                                passwordChangeMessage = "Password updated successfully."
                            } else {
                                passwordChangeMessage = "New password and confirmation do not match."
                            }
                            showPasswordChangeAlert = true
                        }
                    }) {
                        Text("Change Password")
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
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .alert(isPresented: $showPasswordChangeAlert) {
                        Alert(title: Text("Password Change"), message: Text(passwordChangeMessage), dismissButton: .default(Text("OK")))
                    }
                }
                
                Spacer()
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let dbUserViewModel = DBUserViewModel()
        SettingsView()
            .environmentObject(dbUserViewModel)
    }
}
