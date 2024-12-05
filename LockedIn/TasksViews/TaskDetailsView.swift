//
//  TaskDetailsView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/22/24.
//

import SwiftUI

// MARK: - Task Details View
struct TaskDetailsView: View {
    @ObservedObject var dbTaskViewModel: DBTaskViewModel
    @Environment(\.dismiss) private var dismiss // Used to dismiss the view

    var userId: String
    
    @Binding var task: DBTask
    @State private var subtasks: [DBSubtask] = []

    init(task: Binding<DBTask>, dbTaskViewModel: DBTaskViewModel, userId: String) {
        self._task = task
        self.dbTaskViewModel = dbTaskViewModel
        self.userId = userId
        self._subtasks = State(initialValue: task.wrappedValue.subtasks ?? [])
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
                
                SubtasksListView(
                    subtasks: $subtasks,
                    task: $task,
                    dbTaskViewModel: dbTaskViewModel,
                    userId: userId
                )
                
                if subtasks.allSatisfy({ $0.isCompleted }) && !subtasks.isEmpty {
                    HStack {
                        Spacer()
                        CompleteTaskMarker {
                            markTaskAsCompleted()
                        }
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
            .toolbar {
                // Add the Done button to the top-right corner
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white) // Optional: Customize the color
                }
            }
            .onAppear {
                loadSubtasks()
            }
            .onDisappear {
                saveSubtasks()
            }
        }
    }
    
    private func loadSubtasks() {
        if let savedSubtasks = task.subtasks {
            subtasks = Array(Set(savedSubtasks))
        }
    }
    
    private func saveSubtasks() {
        task.subtasks = subtasks
        Task {
            await dbTaskViewModel.updateTask(for: userId, task: task)
        }
    }
    
    private func markTaskAsCompleted() {
        task.isCompleted = true
        Task {
            await dbTaskViewModel.updateTask(for: userId, task: task)
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
    @Binding var subtasks: [DBSubtask]
    @Binding var task: DBTask
    @ObservedObject var dbTaskViewModel: DBTaskViewModel
    var userId: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sub-tasks (\(subtasks.filter { $0.isCompleted }.count)/\(subtasks.count))")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ForEach(subtasks.indices, id: \.self) { index in
                HStack {
                    Button(action: {
                        subtasks[index].isCompleted.toggle()
                        updateSubtasks()
                    }) {
                        Image(systemName: subtasks[index].isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.white)
                    }
                    
                    Text(subtasks[index].name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    private func updateSubtasks() {
        task.subtasks = subtasks
        Task {
            await dbTaskViewModel.updateTask(for: userId, task: task)
        }
    }
}

// MARK: - Complete Task Button
struct CompleteTaskMarker: View {
    let action: () -> Void
    
    var body: some View {
        Text("All Subtasks Completed!")
            .font(.system(size: 18, weight: .bold))
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(Color.green)
            .foregroundColor(.black)
            .cornerRadius(20)
    }
}
