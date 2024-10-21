import SwiftUI

struct FocusView: View {
    
    @State private var isFocus = true
    @State private var focusTimer = 25
    @State private var settedFocusTimer = 25
    @State private var breakTimer = 5
    
    @State private var isRunning = false
    @State private var secondsRemaining = 0
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ModeButtonsView(isFocus: $isFocus)
                
                Spacer().frame(height: 40)
                
                TimerControlsView(
                    isFocus: $isFocus,
                    focusTimer: $focusTimer,
                    settedFocusTimer: $settedFocusTimer,
                    breakTimer: $breakTimer,
                    secondsRemaining: $secondsRemaining,
                    isRunning: $isRunning
                )
                
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
            Text("Lock In")
                .font(.headline)
                .padding()
                .background(isFocus ? Color.white : Color.black)
                .foregroundColor(isFocus ? Color.black : Color.white)
                .cornerRadius(10)
            
            Spacer().frame(width: 70)
            
            Text("Lock Out")
                .font(.headline)
                .padding()
                .background(isFocus ? Color.black : Color.white)
                .foregroundColor(isFocus ? Color.white : Color.black)
                .cornerRadius(10)
        }
        .padding(.top, 40)
    }
}

//struct ModeButtonsView: View {
//    @Binding var isFocus: Bool
//    
//    var body: some View {
//        HStack {
//            Button(action: {
//                isFocus = true
//            }) {
//                Text("Lock In")
//                    .font(.headline)
//                    .padding()
//                    .background(isFocus ? Color.white : Color.black)
//                    .foregroundColor(isFocus ? Color.black : Color.white)
//                    .cornerRadius(10)
//            }
//            
//            Spacer().frame(width: 70)
//            
//            Button(action: {
//                isFocus = false
//            }) {
//                Text("Lock Out")
//                    .font(.headline)
//                    .padding()
//                    .background(isFocus ? Color.black : Color.white)
//                    .foregroundColor(isFocus ? Color.white : Color.black)
//                    .cornerRadius(10)
//            }
//        }
//        .padding(.top, 40)
//    }
//}


struct TimerControlsView: View {
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
                Button(action: {
                    if focusTimer < 60 {
                        focusTimer += 1
                        settedFocusTimer += 1
                    }
                }) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
            }
            
            HStack(spacing: 0) {
                Button(action: { resetTimer() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                }
                
                VStack {
                    Text(timeString())
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
            
            if isFocus {
                Button(action: {
                    if focusTimer > 25 {
                        focusTimer -= 1
                        settedFocusTimer -= 1
                    }
                }) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    func timeString() -> String {
        let currentTimer = isFocus ? focusTimer : breakTimer
        return String(format: "%02d:%02d", currentTimer, secondsRemaining)
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


struct FocusView_Previews: PreviewProvider {
    static var previews: some View {
        FocusView()
    }
}

