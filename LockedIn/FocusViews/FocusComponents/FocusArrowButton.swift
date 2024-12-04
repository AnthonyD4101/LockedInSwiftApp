//
//  FocusArrowButton.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/21/24.
//

import SwiftUI

import SwiftUI

struct FocusArrowButton: View {
    var action: () -> Void
    var systemImage: String
    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass

    var body: some View {
        let orientation = DeviceOrientation(
                    widthSizeClass: widthSizeClass,
                    heightSizeClass: heightSizeClass
                )
        
        let isLandscape = orientation.isLandscape(device: .iPhonePlusOrMax) || orientation.isLandscape(device: .iPhone) || orientation.isLandscape(device: .iPadFull)

        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 200, height: isLandscape ? 50 : 60)

                Image(systemName: systemImage)
                    .font(.system(size: isLandscape ? 30 : 40))
                    .foregroundColor(.white)
            }
        }
    }
}

