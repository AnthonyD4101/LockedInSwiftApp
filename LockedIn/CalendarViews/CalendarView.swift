//
//  CalendarView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var selectedDate = Date()
    @State private var showAddTaskView = false
    
    var body: some View {
        ZStack {
            VStack {
                DatePicker(
                    "Select a date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                .preferredColorScheme(.dark)
                
                VStack(alignment: .leading) {
                    if taskViewModel.tasksFor(date: selectedDate).isEmpty {
                        Text("No tasks for this date.")
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(taskViewModel.tasksFor(date: selectedDate)) { task in
                                    TaskRowView(task: .constant(task)) {
                                        // TODO: Handle task completion
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .onTapGesture {
                                        // TODO: Handle task tap
                                    }
                                    
                                    Divider()
                                        .background(Color.white.opacity(0.3))
                                }
                            }
                        }
                    }
                }
                .padding(.top, 20)
                .background(Color.black)
                .cornerRadius(10)
                .padding()
                
                Spacer()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            
            AddTaskButton(showAddTaskView: $showAddTaskView)
                .padding(.bottom, 40)
        }
        .sheet(isPresented: $showAddTaskView) {
            AddTaskView(tasks: $taskViewModel.tasks)
                .presentationDetents([.fraction(0.8)])
        }
    }
}

#Preview {
    CalendarView(taskViewModel: TaskViewModel())
}

