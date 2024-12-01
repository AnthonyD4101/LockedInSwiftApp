//
//  DeviceOrientation.swift
//  LockedIn
//
//  Created by Nicholas Tran on 12/1/24.
//

import Foundation
import SwiftUI

enum IOSDevice {
    case iPhone; case iPhonePlusOrMax; case iPadFull
}

struct DeviceOrientation {
    var widthSizeClass: UserInterfaceSizeClass?
    var heightSizeClass: UserInterfaceSizeClass?
    
    func isPortrait(device: IOSDevice) -> Bool {
        switch device {
        case IOSDevice.iPadFull:
            return widthSizeClass == .regular && heightSizeClass == .regular
            
        case IOSDevice.iPhone:
            return self.widthSizeClass == .compact && heightSizeClass == .regular
            
        case IOSDevice.iPhonePlusOrMax:
            return widthSizeClass == .compact && heightSizeClass == .regular
        }
    }
    
    func isLandscape(device: IOSDevice) -> Bool {
        switch device {
        case IOSDevice.iPadFull:
            return widthSizeClass == .regular && heightSizeClass == .regular
            
        case IOSDevice.iPhonePlusOrMax:
            return widthSizeClass == .regular && heightSizeClass == .compact
            
        case IOSDevice.iPhone:
            return widthSizeClass == .compact && heightSizeClass == .compact
        }
    }
}
