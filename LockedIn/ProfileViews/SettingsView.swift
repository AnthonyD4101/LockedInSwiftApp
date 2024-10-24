//
//  SettingsView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/24/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            Text("Settings View")
                .font(.system(size: 18))
                .bold()
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SettingsView()
}
