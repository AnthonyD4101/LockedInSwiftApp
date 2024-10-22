//
//  FocusArrowButton.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/21/24.
//

import SwiftUI

struct FocusArrowButton: View {
    var action: () -> Void
    var systemImage: String
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 200, height: 60)
                
                Image(systemName: systemImage)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
        }
    }
}
