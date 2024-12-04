//
//  TaskDetailsView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/22/24.
//

import SwiftUI

// MARK: - Task Details View
struct TaskDetailsView: View {
    @Binding var task: DBTask
    @ObservedObject var dbTaskViewModel: DBTaskViewModel
    var userId: String

    @State private var subtasks: [DBSubtask] = []
    @State private var isLoading = true

    init(task: Binding<DBTask>, dbTaskViewModel: DBTaskViewModel, userId: String) {
        self._task = task
        self.dbTaskViewModel = dbTaskViewModel
        self.userId = userId
        self._subtasks = State(initialValue: task.wrappedValue.subtasks ?? [])
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else {
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
                            CompleteTaskButton {
                                markTaskAsCompleted()
                            }
                            Spacer()
                        }
                        .padding(.vertical, 10)
                    }
                }

                Spacer()
            }
            .padding(.top)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadSubtasks()
            }
            .onDisappear {
                saveSubtasks()
            }
        }
    }

    // MARK: - Helper Functions
    private func loadSubtasks() {
        if let savedSubtasks = task.subtasks {
            subtasks = Array(Set(savedSubtasks))
        }
        isLoading = false
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

struct TaskNameView: View {
    let name: String

    var body: some View {
        Text(name)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal)
    }
}

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
                .background(Color(red: 32 / 255, green: 33 / 255, blue: 33 / 255))
                .cornerRadius(8)
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

struct CompleteTaskButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("All Subtasks Completed!")
                .font(.system(size: 18, weight: .bold))
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(Color.green)
                .foregroundColor(.black)
                .cornerRadius(20)
        }
    }
}

//struct TaskDetailsView_Preview: PreviewProvider {
//    @State static var task = DBTask(
//        id: "1",
//        name: "Sample Task",
//        description: "This is a sample task.",
//        date: Date(),
//        isCompleted: false
//    )
//
//    static var previews: some View {
//        TaskDetailsView(task: $task)
//    }
//}


//// MARK: - Task Details View
//struct TaskDetailsView: View {
//    @Binding var task: UserTask
//    @State private var subtasks: [Subtask]
//    
//    init(task: Binding<UserTask>) {
//        self._task = task
//        self._subtasks = State(initialValue: task.wrappedValue.subtasks)
//    }
//    
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading, spacing: 16) {
//                TaskNameView(name: task.name)
//                TaskDescriptionView(description: task.description)
//                TaskDueDateView(date: task.date)
//                
//                Divider()
//                    .background(Color.white)
//                    .padding(.horizontal)
//                
//                SubtasksListView(subtasks: $subtasks)
//                
//                if subtasks.allSatisfy({ $0.isCompleted }) && !subtasks.isEmpty {
//                    HStack {
//                        Spacer()
//                        CompleteTaskButton {
//                            print("Task completed!")
//                        }
//                        Spacer()
//                    }
//                    .padding(.vertical, 10)
//                }
//                
//                Spacer()
//            }
//            .padding(.top)
//            .background(Color.black.edgesIgnoringSafeArea(.all))
//            .navigationTitle("Task Details")
//            .navigationBarTitleDisplayMode(.inline)
//            .onDisappear {
//                task.subtasks = subtasks
//            }
//        }
//    }
//}
//
//// MARK: - Task Name View
//struct TaskNameView: View {
//    let name: String
//    
//    var body: some View {
//        Text(name)
//            .font(.system(size: 24, weight: .bold))
//            .foregroundColor(.white)
//            .padding(.horizontal)
//    }
//}
//
//// MARK: - Task Description View
//struct TaskDescriptionView: View {
//    let description: String
//    
//    var body: some View {
//        if !description.isEmpty {
//            Text(description)
//                .font(.system(size: 18, weight: .bold))
//                .foregroundColor(.white.opacity(0.7))
//                .padding(.horizontal)
//        } else {
//            Text("No description provided")
//                .font(.system(size: 18, weight: .bold))
//                .foregroundColor(.white.opacity(0.6))
//                .padding(.horizontal)
//        }
//    }
//}
//
//// MARK: - Task Due Date View
//struct TaskDueDateView: View {
//    let date: Date
//    
//    var body: some View {
//        HStack {
//            Image(systemName: "calendar")
//                .foregroundColor(.red)
//            
//            Text("Due Date: \(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none))")
//                .font(.system(size: 16, weight: .bold))
//                .foregroundColor(.white)
//        }
//        .padding(.horizontal)
//    }
//}
//
//// MARK: - Subtasks List View
//struct SubtasksListView: View {
//    @Binding var subtasks: [Subtask]
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Sub-tasks (\(subtasks.filter { $0.isCompleted }.count)/\(subtasks.count))")
//                .font(.headline)
//                .foregroundColor(.white)
//                .padding(.horizontal)
//            
//            ForEach($subtasks) { $subtask in
//                HStack {
//                    Button(action: {
//                        subtask.isCompleted.toggle()
//                    }) {
//                        Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
//                            .foregroundColor(.white)
//                    }
//                    
//                    Text(subtask.name)
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(.white)
//                    
//                    Spacer()
//                }
//                .padding()
//            }
//        }
//    }
//}
//
//// MARK: - Complete Task Button
//struct CompleteTaskButton: View {
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Text("All Subtasks Completed!")
//                .font(.system(size: 18, weight: .bold))
//                .padding(.vertical, 8)
//                .padding(.horizontal, 20)
//                .background(Color.green)
//                .foregroundColor(.black)
//                .cornerRadius(20)
//        }
//    }
//}
//
//// MARK: - Preview
//struct TaskDetailsView_Preview: PreviewProvider {
//    @State static var task = UserTask(name: "Sample Task",
//                                  description: "This is a sample task.",
//                                  date: Date(),
//                                  subtasks: [Subtask(name: "Subtask 1", isCompleted: false),
//                                             Subtask(name: "Subtask 2", isCompleted: false)])
//    
//    static var previews: some View {
//        TaskDetailsView(task: $task)
//    }
//}
