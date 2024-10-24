//
//  CalendarView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var taskViewModel = TaskViewModel()
    @State private var selectedDate = Date()
    @State private var showAddTaskView = false
    @State private var selectedTask: Task? = nil
    
    var body: some View {
        ZStack {
            VStack {
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
                    if taskViewModel.tasksFor(date: selectedDate).isEmpty {
                        Text("No tasks for this date.")
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(taskViewModel.tasksFor(date: selectedDate).indices, id: \.self) { index in
                                    let taskBinding = $taskViewModel.tasks[taskViewModel.tasks.firstIndex(where: { $0.id == taskViewModel.tasksFor(date: selectedDate)[index].id })!]
                                    
                                    TaskRowView(task: taskBinding) {
                                        handleTaskCompletion(at: index)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .onTapGesture {
                                        selectedTask = taskViewModel.tasksFor(date: selectedDate)[index]
                                    }
                                    
                                    Divider()
                                        .background(Color.white.opacity(0.3))
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
            
            AddTaskButton(showAddTaskView: $showAddTaskView)
                .padding(.bottom, 40)
        }
        .sheet(isPresented: $showAddTaskView) {
            AddTaskView(taskViewModel: taskViewModel)
                .presentationDetents([.fraction(0.8)])
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailsView(task: task)
        }
    }
    
    // MARK: - Handle Task Completion (Task Deletion)
    private func handleTaskCompletion(at index: Int) {
        let taskToDelete = taskViewModel.tasksFor(date: selectedDate)[index]
        if let actualIndex = taskViewModel.tasks.firstIndex(where: { $0.id == taskToDelete.id }) {
            taskViewModel.tasks.remove(at: actualIndex)
        }
    }
}


#Preview {
    CalendarView(taskViewModel: TaskViewModel())
}
