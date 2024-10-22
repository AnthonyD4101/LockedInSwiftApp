//
//  FocusControlButton.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/21/24.
//

import SwiftUI

struct FocusControlButton: View {
    var action: () -> Void
    var systemImage: String
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding()
        }
    }
}
