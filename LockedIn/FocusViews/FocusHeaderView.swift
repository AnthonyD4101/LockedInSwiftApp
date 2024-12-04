//
//  ModeHeaderView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/21/24.
//

import SwiftUI

struct FocusHeaderView: View {
    @Binding var isFocus: Bool
    
    var body: some View {
        HStack {
            ModeTitle(title: isFocus ? "Lock In" : "Lock Out")
        }
        .padding(.top, 40)
    }
}

struct ModeTitle: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding()
            .background(Color.white)
            .foregroundColor(Color.black)
            .cornerRadius(10)
    }
}
