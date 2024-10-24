//
//  SignUpView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

// TODO: After SignUp, redirect user to correct view after

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var userEmail: String = ""
    @State private var username: String = ""
    @State private var userCreatePassword: String = ""
    @State private var userConfirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // TODO: Fix some styling (spacing between page elements is a little wonky)
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Heading
                VStack {
                    Text("Create your account!")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .bold()
                        .underline()
                }
                .padding(.top, 70)
                
                Spacer()
                
                // Sign Up Credentials
                VStack(spacing: 16) {
                    UserTextField(title: "Email", text: $userEmail)
                    UserTextField(title: "Username", text: $username)
                    UserTextField(title: "Create Password", text: $userCreatePassword)
                    UserTextField(title: "Confirm Password", text: $userConfirmPassword)
                }
                .padding(.horizontal, 40)
                .padding(.top, 10)
                
                // Sign Up Button
                Button(action: {
                    handleSignUp()
                }) {
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
                .padding(.top, 30)
                
                Spacer()
            }
            .padding(.bottom, 40)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // MARK: - Sign Up Handling
    private func handleSignUp() {
        guard userCreatePassword == userConfirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        let success = userViewModel.signUp(email: userEmail, username: username, password: userCreatePassword)
        
        if success {
            alertMessage = "Sign-up successful!"
            showAlert = true
        } else {
            alertMessage = "Email or username already exists"
            showAlert = true
        }
    }
}

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
