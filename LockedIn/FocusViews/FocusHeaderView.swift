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
            ModeTitle(title: "Lock In", isActive: isFocus)
            Spacer().frame(width: 70)
            ModeTitle(title: "Lock Out", isActive: !isFocus)
        }
        .padding(.top, 40)
    }
}

struct ModeTitle: View {
    var title: String
    var isActive: Bool
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding()
            .background(isActive ? Color.white : Color.black)
            .foregroundColor(isActive ? Color.black : Color.white)
            .cornerRadius(10)
    }
}
