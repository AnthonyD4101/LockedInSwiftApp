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
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                FocusHeaderView(isFocus: $isFocus)
                
                Spacer()
                
                FocusDisplayView(
                    isFocus: $isFocus,
                    focusTimer: $focusTimer,
                    settedFocusTimer: $settedFocusTimer,
                    breakTimer: $breakTimer,
                    secondsRemaining: $secondsRemaining,
                    isRunning: $isRunning
                )
                .frame(maxWidth: .infinity)
                .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}


struct FocusView_Previews: PreviewProvider {
    static var previews: some View {
        FocusView()
    }
}

