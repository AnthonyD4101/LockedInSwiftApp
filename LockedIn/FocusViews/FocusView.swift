//
//  FocusView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct FocusView: View {
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            Text("Focus View")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    FocusView()
}
