//
//  TaskDetailsView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/22/24.
//

import SwiftUI
import GRDB

// TODO: Add "Complete Task" Functionality
// If a user checks off all subtasks, a "Complete Task" button shows up
// A user should be able to click this button, which in return will remove
// said task from the task list

// MARK: - Task Details View
struct TaskDetailsView: View {
    @State var task: Task
    @State private var subtasks: [Subtask] = []
    @State private var completedSubtasks: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                TaskNameView(name: task.title)
                
                if let description = task.description, !description.isEmpty {
                    TaskDescriptionView(description: description)
                } else {
                    TaskDescriptionView(description: "No description provided")
                }
                
                if let date = parseDate(from: task.dueDate) {
                    TaskDueDateView(date: date)
                } else {
                    Text("Invalid Due Date")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                Divider()
                    .background(Color.white)
                    .padding(.horizontal)
                
                SubtasksListView(subtasks: $subtasks, completedSubtasks: $completedSubtasks)
                
                Spacer()
            }
            .padding(.top)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadSubtasks(for: task.id)
        }
        .onChange(of: subtasks) {
            completedSubtasks = subtasks.filter { $0.isCompleted }.count
        }
    }
    
    // Function to load subtasks from the database
    private func loadSubtasks(for taskId: Int64?) {
        guard let taskId = taskId else { return }
        
        do {
            try DatabaseManager.shared.dbQueue?.read { db in
                let fetchedSubtasks = try Subtask.filter(Column("taskId") == taskId).fetchAll(db)
                print("Fetched subtasks for taskId \(taskId): \(fetchedSubtasks)")
                subtasks = fetchedSubtasks
                completedSubtasks = fetchedSubtasks.filter { $0.isCompleted }.count
            }
        } catch {
            print("Error fetching subtasks: \(error)")
        }
    }
    
    private func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
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
            
            ForEach(subtasks) { subtask in
                HStack {
                    Button(action: {
                        if let index = subtasks.firstIndex(where: { $0.id == subtask.id }) {
                            subtasks[index].isCompleted.toggle()
                            completedSubtasks = subtasks.filter { $0.isCompleted }.count
                        }
                    }) {
                        Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.white)
                    }
                    
                    Text(subtask.title)
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
    TaskDetailsView(task: Task(
        id: 1,
        userId: 1,
        title: "Sample Task",
        description: "This is a sample task.",
        dueDate: "2024-12-31",
        isCompleted: false
    ))
}
