//
//  CalendarView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            Text("Calendar View")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    CalendarView()
}
