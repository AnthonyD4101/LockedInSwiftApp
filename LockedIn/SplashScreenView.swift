//
//  SplashScreen.swift
//  LockedIn
//
//  Created by Nicholas Tran on 12/3/24.
//

import Foundation

import SwiftUI

struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5

    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                Image("LockedInLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 500, maxHeight: 500)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

