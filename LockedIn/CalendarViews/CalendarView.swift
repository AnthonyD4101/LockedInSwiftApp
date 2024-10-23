//
//  CalendarView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            DatePicker(
                "Select a date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding(.top, -50)
            .frame(maxHeight: UIScreen.main.bounds.height / 2)
            .preferredColorScheme(.dark)
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    CalendarView()
}
