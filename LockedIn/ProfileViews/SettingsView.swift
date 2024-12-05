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
    
    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass
    
    var body: some View {
        let orientation = DeviceOrientation(
            widthSizeClass: widthSizeClass,
            heightSizeClass: heightSizeClass
        )
        
        let isLandscape = orientation.isLandscape(device: .iPhone) || orientation.isLandscape(device: .iPadFull)

        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            if isLandscape {
                // Landscape layout with two columns
                HStack(spacing: 0) {
                    // Left column: Email/Username
                    VStack(alignment: .leading, spacing: 16) {
                        // Email Change
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Change Email")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                            
                            TextField("New Email", text: $newEmail)
                                .padding()
                                .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding(.trailing, 20)

                        // Username Change
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Change Username")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                            
                            TextField("New Username", text: $newUsername)
                                .padding()
                                .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding(.trailing, 20)
                        
                        // Save Changes Button
                        Button(action: {
                            Task {
                                infoChangeMessage = ""
                                
                                if !newEmail.isEmpty {
                                    await dbUserViewModel.updateEmail(newEmail: newEmail)
                                    infoChangeMessage += "Email updated successfully.\n"
                                    newEmail = ""
                                }
                                
                                if !newUsername.isEmpty {
                                    await dbUserViewModel.updateUsername(newUsername: newUsername)
                                    infoChangeMessage += "Username updated successfully."
                                    newUsername = ""
                                }
                                
                                if infoChangeMessage.isEmpty {
                                    infoChangeMessage = "No changes were made."
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
                        .alert(isPresented: $showInfoChangeAlert) {
                            Alert(title: Text("Changes Saved"), message: Text(infoChangeMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 40)
                    
                    // Right column: Password fields
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Change Password")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .bold()
                        
                        SecureField("Current Password", text: $currentPassword)
                            .padding()
                            .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        SecureField("New Password", text: $newPassword)
                            .padding()
                            .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        SecureField("Confirm New Password", text: $confirmPassword)
                            .padding()
                            .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
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
                        .padding(.top, 10)
                        .alert(isPresented: $showPasswordChangeAlert) {
                            Alert(title: Text("Password Update"), message: Text(passwordChangeMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 20)
                }
            } else {
                // Portrait layout
                VStack(spacing: 0) {
                    Text("Settings")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    // Existing portrait layout
                    VStack(alignment: .leading, spacing: 16) {
                        // Email Change
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Change Email")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                            
                            TextField("New Email", text: $newEmail)
                                .padding()
                                .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        
                        // Username Change
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Change Username")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                            
                            TextField("New Username", text: $newUsername)
                                .padding()
                                .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        
                        // Save Changes Button
                        Button(action: {
                            Task {
                                infoChangeMessage = ""
                                
                                if !newEmail.isEmpty {
                                    await dbUserViewModel.updateEmail(newEmail: newEmail)
                                    infoChangeMessage += "Email updated successfully.\n"
                                    newEmail = ""
                                }
                                
                                if !newUsername.isEmpty {
                                    await dbUserViewModel.updateUsername(newUsername: newUsername)
                                    infoChangeMessage += "Username updated successfully."
                                    newUsername = ""
                                }
                                
                                if infoChangeMessage.isEmpty {
                                    infoChangeMessage = "No changes were made."
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
                        .alert(isPresented: $showInfoChangeAlert) {
                            Alert(title: Text("Changes Saved"), message: Text(infoChangeMessage), dismissButton: .default(Text("OK")))
                        }
                        
                        // Change Password Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Change Password")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                            
                            SecureField("Current Password", text: $currentPassword)
                                .padding()
                                .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            
                            SecureField("New Password", text: $newPassword)
                                .padding()
                                .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            
                            SecureField("Confirm New Password", text: $confirmPassword)
                                .padding()
                                .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        
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
                        .alert(isPresented: $showPasswordChangeAlert) {
                            Alert(title: Text("Password Update"), message: Text(passwordChangeMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding(.horizontal, 40)
                }
            }
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
