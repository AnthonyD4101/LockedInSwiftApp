//
//  SignInView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 9/27/24.
//

import SwiftUI

struct SignInView: View {
    @Binding var isSignedIn: Bool
    @State private var username: String = ""
    @State private var userPassword: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Logo and Heading
                    VStack(spacing: 16) {
                        Image("LockedInLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300, maxHeight: 300)
                            .shadow(color: Color.white.opacity(0.5), radius: 30, x: 0, y: 0)
                            .shadow(color: Color.white.opacity(0.8), radius: 15, x: 0, y: 0)
                        
                        
                        Text("Welcome to LockedIn")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .bold()
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Sign In Credentials
                    VStack(spacing: 8) {
                        VStack(alignment: .leading) {
                            Text("Email/Username")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                                .padding(.horizontal, 40)
                            
                            
                            TextField("", text: $username)
                                .padding()
                                .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                                .cornerRadius(8)
                                .padding(.horizontal, 40)
                                .shadow(radius: 5)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 16)
                        
                        VStack(alignment: .leading) {
                            Text("Password")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                                .padding(.horizontal, 40)
                            
                            SecureField("", text: $userPassword)
                                .padding()
                                .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                                .cornerRadius(8)
                                .padding(.horizontal, 40)
                                .shadow(radius: 5)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            // TODO: Implement SignIn Button Funtionality
                            isSignedIn = true
                            print("Sign In Clicked")
                        }) {
                            Text("Sign In")
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
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .gradientForeground(colors: [.cyan, .blue])
                                .font(.system(size: 18))
                                .bold()
                                .underline()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

#Preview {
    SignInView(isSignedIn: .constant(false))
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
