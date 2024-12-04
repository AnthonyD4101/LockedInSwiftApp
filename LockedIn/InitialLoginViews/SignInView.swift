//
//  SignInView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 9/27/24.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var dbUserViewModel: DBUserViewModel
    @Binding var isSignedIn: Bool
    @State private var username: String = ""
    @State private var userPassword: String = ""
    @State private var loginFailed: Bool = false
    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass
    
    var body: some View {
        let orientation = DeviceOrientation(
            widthSizeClass: widthSizeClass,
            heightSizeClass: heightSizeClass
        )
        
        NavigationView {
            ZStack {
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                if orientation.isLandscape(device: .iPadFull) ||
                   orientation.isLandscape(device: .iPhone) ||
                   orientation.isLandscape(device: .iPhonePlusOrMax) {
                    
                    HStack {
                        VStack(spacing: 0) {
                            Image("LockedInLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                                .shadow(color: Color.white.opacity(0.5), radius: 30, x: 0, y: 0)
                                .shadow(color: Color.white.opacity(0.8), radius: 15, x: 0, y: 0)
                            
                            Text("Welcome to LockedIn")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        
                        formView
                            .frame(maxWidth: 400)
                            .padding(.horizontal, 16)
                    }
                } else {
                    VStack {
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
                                                
                        formView
                            .padding(.bottom, 40)
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    var formView: some View {
        VStack(spacing: 8) {
            VStack(alignment: .leading) {
                Text("Email/Username")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .bold()
                    .padding(.horizontal, 16)
                
                TextField("", text: $username)
                    .padding()
                    .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .shadow(radius: 5)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(.bottom, 16)
            
            VStack(alignment: .leading) {
                Text("Password")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .bold()
                    .padding(.horizontal, 16)
                
                SecureField("", text: $userPassword)
                    .padding()
                    .background(Color(red: 32/255, green: 33/255, blue: 33/255))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .shadow(radius: 5)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            if loginFailed {
                Text("Invalid username or password")
                    .foregroundColor(.red)
            }
            
            Button(action: {
                Task {
                    let success = await dbUserViewModel.logIn(email: username, password: userPassword)
                    if success {
                        isSignedIn = true
                    } else {
                        loginFailed = true
                    }
                }
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
            .padding(.top, 20)
                        
            // Create Account
            VStack(spacing: 8) {
                Text("Don't have an account?")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .bold()
                
                NavigationLink(destination: SignUpView().environmentObject(dbUserViewModel)) {
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

// MARK: - Preview
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        let dbUserViewModel = DBUserViewModel()
        
        SignInView(isSignedIn: .constant(false))
            .environmentObject(dbUserViewModel)
    }
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
