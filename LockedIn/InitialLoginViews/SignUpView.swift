//
//  SignUpView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    // @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var dbUserViewModel: DBUserViewModel
    @State private var userEmail: String = ""
    @State private var username: String = ""
    @State private var userCreatePassword: String = ""
    @State private var userConfirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass
    
    var body: some View {
        let orientation = DeviceOrientation(
            widthSizeClass: widthSizeClass,
            heightSizeClass: heightSizeClass
        )
        
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Title
                Text("Create your account!")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .bold()
                    .underline()
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                
                Spacer()
                
                if orientation.isLandscape(device: .iPadFull) ||
                    orientation.isLandscape(device: .iPhone) ||
                    orientation.isLandscape(device: .iPhonePlusOrMax) {
                    
                    // Two-Column Layout for Text Fields
                    HStack(spacing: 30) {
                        VStack(spacing: 16) {
                            UserTextField(title: "Email", text: $userEmail)
                            UserTextField(title: "Username", text: $username)
                        }
                        .frame(maxWidth: 300)
                        
                        VStack(spacing: 16) {
                            UserTextField(title: "Create Password", text: $userCreatePassword)
                            UserTextField(title: "Confirm Password", text: $userConfirmPassword)
                        }
                        .frame(maxWidth: 300)
                    }
                } else {
                    // Vertical Layout for Text Fields in Portrait
                    VStack(spacing: 16) {
                        UserTextField(title: "Email", text: $userEmail)
                        UserTextField(title: "Username", text: $username)
                        UserTextField(title: "Create Password", text: $userCreatePassword)
                        UserTextField(title: "Confirm Password", text: $userConfirmPassword)
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Sign-Up Button
                Button(action: {
                    handleSignUp()
                })
                {
                    Text("Sign Up")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 320)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(8)
                }
                .padding(.bottom, 40)
                .padding(.top, 30)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // TODO: Testing DB SignUp
    private func handleSignUp() {
        guard userCreatePassword == userConfirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        Task {
            let success = await dbUserViewModel.signUp(email: userEmail, username: username, password: userCreatePassword)
            
            if success {
                alertMessage = "Sign-up successful!"
                showAlert = true
                // TODO: Navigate to the correct view after sign-up
            } else {
                alertMessage = "Error during sign-up. Please try again."
                showAlert = true
            }
        }
    }
    
    // MARK: - Sign-Up Handling
    //    private func handleSignUp() {
    //        guard userCreatePassword == userConfirmPassword else {
    //            alertMessage = "Passwords do not match"
    //            showAlert = true
    //            return
    //        }
    //
    //        let success = userViewModel.signUp(email: userEmail, username: username, password: userCreatePassword)
    //
    //        if success {
    //            alertMessage = "Sign-up successful!"
    //            showAlert = true
    //        } else {
    //            alertMessage = "Email or username already exists"
    //            showAlert = true
    //        }
    //    }
}

// MARK: - Helper Views
struct UserTextField: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 18))
                .bold()
            
            TextField("", text: $text)
                .padding()
                .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                .cornerRadius(8)
                .shadow(radius: 5)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        
        SignUpView()
            .environmentObject(userViewModel)
    }
}
