//
//  SignInView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 9/27/24.
//

import SwiftUI

struct SignInView: View {
    @State private var username: String = ""
    @State private var userPassword: String = ""
    
    // TODO: Fix Styling
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Logo and Heading
                VStack(spacing: 16) {
                    // TODO: Add Logo
                    Text("Welcome to LockedIn")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .bold()
                }
                .padding()
                
                Spacer()
                
                // Sign In Credentials
                VStack(spacing: 24) {
                    Text("Email/Username")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                    TextField("Enter your email or username", text: $username)
                        .padding()
                        .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                        .shadow(radius: 5)
                        .foregroundColor(.black)
                    
                    Text("Password")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                    TextField("Enter your password", text: $userPassword)
                        .padding()
                        .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                        .shadow(radius: 5)
                        .foregroundColor(.black)
                    
                    Button(action: {
                        // TODO: Implement SignIn Button Funtionality
                    }) {
                        Text("Sign In")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(30)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                Spacer()
                
                // Create Account
                VStack(spacing: 8) {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                    Text("Sign Up")
                        .gradientForeground(colors: [.cyan, .blue])
                        .font(.system(size: 18))
                        .bold()
                        .underline()
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    SignInView()
}


// TODO: Find out if there is a better way to implement this
// Color Gradients Extension
extension View {
    func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(gradient: Gradient(colors: colors),
                           startPoint: .leading,
                           endPoint: .trailing)
        )
        .mask(self)
    }
}
