//
//  CalendarView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

// TODO: make it so on the selected date when u click add task, set to that date automatically
// TODO: the button goes off screen, make the tasks scrollable

import SwiftUI

struct CalendarView: View {
    @ObservedObject var dbUserViewModel: DBUserViewModel
    @ObservedObject var dbTaskViewModel: DBTaskViewModel
    
    @State private var selectedDate = Date()
    @State private var showAddTaskView = false
    @State private var selectedTask: DBTask? = nil
    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass
    
    var body: some View {
        let orientation = DeviceOrientation(
            widthSizeClass: widthSizeClass,
            heightSizeClass: heightSizeClass
        )
        
        ZStack {
            if orientation.isLandscape(device: .iPhonePlusOrMax) || orientation.isLandscape(device: .iPhone) || orientation.isLandscape(device: .iPadFull) {
                HStack(spacing: 20) {
                    // Calendar on the left
                    DatePicker(
                        "Select a date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(width: UIScreen.main.bounds.width * 0.4)
                    .preferredColorScheme(.dark)
                    .background(Color.black)
                    .cornerRadius(10)
                    
                    // Tasks on the right
                    VStack(alignment: .leading) {
                        let dailyTasks = dbTaskViewModel.tasksFor(date: selectedDate)
                        
                        if dailyTasks.isEmpty {
                            Text("No tasks for this date.")
                                .foregroundColor(.white)
                                .padding()
                        } else {
                            ScrollView {
                                VStack(alignment: .leading) {
                                    ForEach(dailyTasks, id: \.id) { task in
                                        if let index = dbTaskViewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                            TaskRowView(task: $dbTaskViewModel.tasks[index]) {
                                                handleTaskCompletion(task: task)
                                            }
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .onTapGesture {
                                                selectedTask = task
                                            }
                                            
                                            Divider()
                                                .background(Color.white.opacity(0.3))
                                        }
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.55)
                            .background(Color.black)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                VStack {
                    // DatePicker for selecting a date
                    DatePicker(
                        "Select a date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .preferredColorScheme(.dark)
                    .background(Color.black)
                    
                    // Tasks for the selected date
                    VStack(alignment: .leading) {
                        let dailyTasks = dbTaskViewModel.tasksFor(date: selectedDate)
                        
                        if dailyTasks.isEmpty {
                            Text("No tasks for this date.")
                                .foregroundColor(.white)
                                .padding()
                        } else {
                            ScrollView {
                                VStack(alignment: .leading) {
                                    ForEach(dailyTasks, id: \.id) { task in
                                        if let index = dbTaskViewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                            TaskRowView(task: $dbTaskViewModel.tasks[index]) {
                                                handleTaskCompletion(task: task)
                                            }
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .onTapGesture {
                                                selectedTask = task
                                            }
                                            
                                            Divider()
                                                .background(Color.white.opacity(0.3))
                                        }
                                    }
                                }
                            }
                            .background(Color.black)
                            .cornerRadius(10)
                        }
                        
                        Spacer()
                    }
                }
            }
            
            // Add Task Button
            AddTaskButton(showAddTaskView: $showAddTaskView)
                .position(
                    x: orientation.isLandscape(device: .iPhonePlusOrMax) || orientation.isLandscape(device: .iPhone) || orientation.isLandscape(device: .iPadFull) ?
                    UIScreen.main.bounds.width - 80 : UIScreen.main.bounds.width - 60,
                    y: orientation.isLandscape(device: .iPhonePlusOrMax) || orientation.isLandscape(device: .iPhone) || orientation.isLandscape(device: .iPadFull) ?
                    UIScreen.main.bounds.height - 100 : UIScreen.main.bounds.height - 200
                )
        }
        .sheet(isPresented: $showAddTaskView) {
            AddTaskView(dbTaskViewModel: dbTaskViewModel, userId: dbUserViewModel.currentUser?.id ?? "")
                .presentationDetents([.fraction(0.8)])
        }
        .sheet(item: $selectedTask) { selectedTask in
            if let index = dbTaskViewModel.tasks.firstIndex(where: { $0.id == selectedTask.id }),
               let userId = dbUserViewModel.currentUser?.id {
                TaskDetailsView(task: $dbTaskViewModel.tasks[index], dbTaskViewModel: dbTaskViewModel, userId: userId)
            }
        }
    }
    
    // MARK: - Handle Task Completion (Task Deletion)
    private func handleTaskCompletion(task: DBTask) {
        if let userId = dbUserViewModel.currentUser?.id {
            Task {
                await dbTaskViewModel.removeTask(for: userId, task: task)
            }
        }
    }
}

#Preview {
    let dbUserViewModel = DBUserViewModel()
    let dbTaskViewModel = DBTaskViewModel()

    CalendarView(dbUserViewModel: dbUserViewModel, dbTaskViewModel: dbTaskViewModel)
}
