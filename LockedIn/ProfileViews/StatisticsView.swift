//
//  StatisticsView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/24/24.
//

// TODO: Fix Statistics Data Fetch Logic
// Right now, if you clear a task, it goes away from app statistic
// calculation, so we need a way to keep track of those

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var dbTaskViewModel: DBTaskViewModel
    
    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass
    
    var body: some View {
        let orientation = DeviceOrientation(
                    widthSizeClass: widthSizeClass,
                    heightSizeClass: heightSizeClass
                )
        
        let isLandscape = orientation.isLandscape(device: .iPhonePlusOrMax) || orientation.isLandscape(device: .iPhone) || orientation.isLandscape(device: .iPadFull)

        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            if isLandscape{
                HStack {
                    // chart.bar.xaxis
                    // chart.line.uptrend.xyaxis
                    Image(systemName: "chart.bar.xaxis")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.orange)
                        .padding(.top, 40)
                    
                    Text("Information locked in, just for you!")
                        .foregroundColor(.white)
                        .font(.system(size: 28))
                        .bold()
                        .padding(.top, 16)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    // Statistics Data
                    VStack(alignment: .leading, spacing: 16) {
                        StatisticRow(title: "Total Tasks", value: "\(dbTaskViewModel.totalTasks)")
                        StatisticRow(title: "Completed Tasks", value: "\(dbTaskViewModel.completedTasks)")
                        StatisticRow(title: "Total Subtasks", value: "\(dbTaskViewModel.totalSubtasks)")
                        StatisticRow(title: "Completed Subtasks", value: "\(dbTaskViewModel.completedSubtasks)")
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
            else{
                VStack {
                    // chart.bar.xaxis
                    // chart.line.uptrend.xyaxis
                    Image(systemName: "chart.bar.xaxis")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.orange)
                        .padding(.top, 40)
                    
                    Text("Information locked in, just for you!")
                        .foregroundColor(.white)
                        .font(.system(size: 28))
                        .bold()
                        .padding(.top, 16)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    // Statistics Data
                    VStack(alignment: .leading, spacing: 16) {
                        StatisticRow(title: "Total Tasks", value: "\(dbTaskViewModel.totalTasks)")
                        StatisticRow(title: "Completed Tasks", value: "\(dbTaskViewModel.completedTasks)")
                        StatisticRow(title: "Total Subtasks", value: "\(dbTaskViewModel.totalSubtasks)")
                        StatisticRow(title: "Completed Subtasks", value: "\(dbTaskViewModel.completedSubtasks)")
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
        }
    }
}

struct StatisticRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 18))
                .bold()
            
            Spacer()
            
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 18))
        }
        .padding()
        .background(Color(red: 32/255, green: 33/255, blue: 33/255))
        .cornerRadius(8)
    }
}

// MARK: - Preview
struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        let taskViewModel = TaskViewModel()
        
        StatisticsView()
            .environmentObject(taskViewModel)
    }
}
