//
//  TaskDetailsView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/22/24.
//

import SwiftUI

// TODO: Add "Complete Task" Functionality
// If a user checks off all subtasks, a "Complete Task" button shows up
// A user should be able to click this button, which in return will remove
// said task from the task list

// MARK: - Task Details View
struct TaskDetailsView: View {
    let task: Task
    @State private var completedSubtasks: Int = 0
    @State private var subtasks: [Subtask]
    
    init(task: Task) {
        self.task = task
        self._subtasks = State(initialValue: task.subtasks.map { Subtask(name: $0, isCompleted: false) })
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                TaskNameView(name: task.name)
                TaskDescriptionView(description: task.description)
                TaskDueDateView(date: task.date)
                
                Divider()
                    .background(Color.white)
                    .padding(.horizontal)
                
                SubtasksListView(subtasks: $subtasks, completedSubtasks: $completedSubtasks)
                
                if completedSubtasks == subtasks.count && subtasks.count > 0 {
                    HStack {
                        Spacer()
                        CompleteTaskButton()
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
                
                Spacer()
            }
            .padding(.top)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Task Name View
struct TaskNameView: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal)
    }
}

// MARK: - Task Description View
struct TaskDescriptionView: View {
    let description: String
    
    var body: some View {
        if !description.isEmpty {
            Text(description)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
                .padding(.horizontal)
        } else {
            Text("No description provided")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal)
        }
    }
}

// MARK: - Task Due Date View
struct TaskDueDateView: View {
    let date: Date
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(.red)
            
            Text("Due Date: \(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none))")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
}

// MARK: - Subtasks List View
struct SubtasksListView: View {
    @Binding var subtasks: [Subtask]
    @Binding var completedSubtasks: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sub-tasks (\(completedSubtasks)/\(subtasks.count))")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ForEach($subtasks) { $subtask in
                HStack {
                    Button(action: {
                        subtask.isCompleted.toggle()
                        completedSubtasks = subtasks.filter { $0.isCompleted }.count
                    }) {
                        Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.white)
                    }
                    
                    Text(subtask.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

// MARK: - Complete Task Button
struct CompleteTaskButton: View {
    var body: some View {
        Text("Complete Task")
            .font(.system(size: 18, weight: .bold))
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(Color.green)
            .foregroundColor(.black)
            .cornerRadius(20)
    }
}

// MARK: - Preview
#Preview {
    TaskDetailsView(task: Task(name: "Sample Task", description: "This is a sample task.", date: Date(), subtasks: ["Subtask 1", "Subtask 2"]))
}