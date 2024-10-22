//
//  FocusModeTimerDisplay.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/21/24.
//

import SwiftUI

struct FocusDisplayView: View {
    @Binding var isFocus: Bool
    @Binding var focusTimer: Int
    @Binding var settedFocusTimer: Int
    @Binding var breakTimer: Int
    @Binding var secondsRemaining: Int
    @Binding var isRunning: Bool
    
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            if isFocus {
                FocusArrowButton(action: increaseFocusTime, systemImage: "arrow.up")
            }
            
            HStack(spacing: -10) {
                FocusControlButton(action: resetTimer, systemImage: "arrow.clockwise")
                FocusTimerDisplay(timeString: timeString())
                FocusControlButton(action: toggleTimer, systemImage: isRunning ? "pause.fill" : "play.fill")
            }
            
            if isFocus {
                FocusArrowButton(action: decreaseFocusTime, systemImage: "arrow.down")
            }
        }
    }
    
    func increaseFocusTime() {
        if focusTimer < 60 {
            focusTimer += 1
            settedFocusTimer += 1
        }
    }
    
    func decreaseFocusTime() {
        if focusTimer > 25 {
            focusTimer -= 1
            settedFocusTimer -= 1
        }
    }
    
    func timeString() -> String {
        let currentTimer = isFocus ? focusTimer : breakTimer
        return String(format: "%02d:%02d", currentTimer, secondsRemaining)
    }
    
    func toggleTimer() {
        isRunning ? stopTimer() : startTimer()
    }
    
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timerTick()
        }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        stopTimer()
        focusTimer = 25
        settedFocusTimer = 25
        secondsRemaining = 0
    }
    
    func switchToBreakMode() {
        breakTimer = max(settedFocusTimer - 20, 5)
        stopTimer()
        isFocus = false
        secondsRemaining = 0
    }
    
    func switchToFocusMode() {
        focusTimer = settedFocusTimer
        stopTimer()
        isFocus = true
        secondsRemaining = 0
    }
    
    func timerTick() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
        } else {
            isFocus ? handleFocusMode() : handleBreakMode()
        }
    }
    
    func handleFocusMode() {
        if focusTimer > 0 {
            focusTimer -= 1
            secondsRemaining = 59
        } else {
            switchToBreakMode()
        }
    }
    
    func handleBreakMode() {
        if breakTimer > 0 {
            breakTimer -= 1
            secondsRemaining = 59
        } else {
            switchToFocusMode()
        }
    }
}
