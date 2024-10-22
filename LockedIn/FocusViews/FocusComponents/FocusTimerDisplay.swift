//
//  FocusTimerDisplay.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/21/24.
//

import SwiftUI

struct FocusTimerDisplay: View {
    var timeString: String
    
    var body: some View {
        VStack {
            Text(timeString)
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .frame(width: 250, height: 100, alignment: .center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 4)
                .padding(20)
        )
    }
}


