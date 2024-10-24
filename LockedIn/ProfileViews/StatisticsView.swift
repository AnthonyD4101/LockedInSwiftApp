//
//  StatisticsView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/24/24.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            Text("Statistics View")
                .font(.system(size: 18))
                .bold()
                .foregroundColor(.white)
        }
    }
}

#Preview {
    StatisticsView()
}
