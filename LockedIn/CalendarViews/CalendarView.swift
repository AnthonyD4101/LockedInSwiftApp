//
//  CalendarView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var dbUserViewModel: DBUserViewModel
    @ObservedObject var dbTaskViewModel: DBTaskViewModel
    @State private var selectedDate = Date()
    @State private var showAddTaskView = false
    @State private var selectedTask: DBTask? = nil

    var body: some View {
        ZStack {
            VStack {
                // Date Picker
                DatePicker(
                    "Select a date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(height: UIScreen.main.bounds.height * 0.5)
                .preferredColorScheme(.dark)
                .background(Color.black)

                VStack(alignment: .leading) {
                    // Filter tasks by selected date
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
                    }
                }
                .background(Color.black)
                .cornerRadius(10)

                Spacer()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)

            // Add Task Button
            AddTaskButton(showAddTaskView: $showAddTaskView)
                .padding(.bottom, 40)
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

    // MARK: - Handle Task Completion
    private func handleTaskCompletion(task: DBTask) {
        if let userId = dbTaskViewModel.tasks.first?.id { // Replace with the actual user ID
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
        .environmentObject(dbUserViewModel)
        .environmentObject(dbTaskViewModel)
}
