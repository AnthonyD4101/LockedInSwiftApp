import SwiftUI

struct FocusView: View {
    
    @State private var isFocus = true
    @State private var focusTimer = 1 {
        didSet {
            breakTimer = max(focusTimer - 20, 5)
        }
    }
    @State private var breakTimer = 5
    @State private var isRunning = false
    @State private var secondsRemaining = 0
    
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ModeButtonsView(isFocus: $isFocus)
                
                Spacer().frame(height: 40)
                
                TimerControlsView(isFocus: $isFocus, focusTimer: $focusTimer, breakTimer: $breakTimer, secondsRemaining: $secondsRemaining, isRunning: $isRunning)
                
                Spacer()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

struct ModeButtonsView: View {
    @Binding var isFocus: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                isFocus = true
            }) {
                Text("Focus Time")
                    .font(.headline)
                    .padding()
                    .background(isFocus ? Color.white : Color.black)
                    .foregroundColor(isFocus ? Color.black : Color.white)
                    .cornerRadius(10)
            }
            
            Spacer().frame(width: 70)
            
            Button(action: {
                isFocus = false
            }) {
                Text("Break Mode")
                    .font(.headline)
                    .padding()
                    .background(isFocus ? Color.black : Color.white)
                    .foregroundColor(isFocus ? Color.white : Color.black)
                    .cornerRadius(10)
            }
        }
        .padding(.top, 40)
    }
}

struct TimerControlsView: View {
    @Binding var isFocus: Bool
    @Binding var focusTimer: Int
    @Binding var breakTimer: Int
    @Binding var secondsRemaining: Int
    @Binding var isRunning: Bool
    
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            Button(action: {
                if isFocus {
                    if focusTimer < 60 {
                        focusTimer += 1
                    }
                }
            }) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            HStack(spacing: -10) {
                Button(action: { resetTimer() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                }
                
                VStack {
                    Text(isFocus ? "\(focusTimer):\(String(format: "%02d", secondsRemaining))" : "\(breakTimer):\(String(format: "%02d", secondsRemaining))")
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
                
                Button(action: { toggleTimer() }) {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding()
                }
            }
            
            Button(action: {
                if isFocus {
                    if focusTimer > 25 {
                        focusTimer -= 1
                    }
                }
            }) {
                Image(systemName: "arrow.down")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
        }
    }
    
    func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                if isFocus {
                    if focusTimer > 0 {
                        focusTimer -= 1
                        secondsRemaining = 59
                    } else {
                        switchToBreakMode()
                    }
                } else {
                    if breakTimer > 0 {
                        breakTimer -= 1
                        secondsRemaining = 59
                    } else {
                        switchToFocusMode()
                    }
                }
            }
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
        breakTimer = 5
        secondsRemaining = 0
    }
    
    func switchToBreakMode() {
        stopTimer()
        isFocus = false
        breakTimer = 5
        secondsRemaining = 0
    }

    func switchToFocusMode() {
        stopTimer()
        isFocus = true
        focusTimer = 25
        secondsRemaining = 0
    }
}

#Preview {
    FocusView()
}

