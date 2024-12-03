//
//  AddTaskView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/21/24.
//

import SwiftUI

// MARK: - Add Task View
struct AddTaskView: View {
    @ObservedObject var dbTaskViewModel: DBTaskViewModel
    var userId: String

    @State private var newTaskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = Date()
    @State private var subtasks: [DBSubtask] = []
    @State private var newSubtaskName: String = ""

    @State private var showSuccessMessage: Bool = false
    @State private var messageOpacity: Double = 0.0

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                TaskNameInput(taskName: $newTaskName)
                TaskDescriptionInput(taskDescription: $taskDescription)
                TaskDatePicker(taskDate: $taskDate)

                Divider()
                    .background(Color.white)
                    .padding(.horizontal)

                SubtasksView(subtasks: $subtasks, newSubtask: $newSubtaskName)

                if showSuccessMessage {
                    Text("Task created successfully!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .opacity(messageOpacity)
                        .padding(.horizontal)
                        .animation(.easeInOut(duration: 0.5), value: messageOpacity)
                }

                Spacer()

                Button(action: {
                    createTask()
                }) {
                    Text("Create Task")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                resetForm()
            }
        }
    }

    private func createTask() {
        guard !newTaskName.isEmpty else { return }

        let newTask = DBTask(
            id: nil,
            name: newTaskName,
            description: taskDescription,
            date: taskDate,
            isCompleted: false
        )

        Task {
            await dbTaskViewModel.addTask(for: userId, task: newTask)
            resetForm()
            showSuccessMessage = true
            messageOpacity = 1.0

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    messageOpacity = 0.0
                }
            }
        }
    }

    private func resetForm() {
        newTaskName = ""
        taskDescription = ""
        taskDate = Date()
        subtasks = []
        messageOpacity = 0.0
    }
}

struct TaskNameInput: View {
    @Binding var taskName: String

    var body: some View {
        ZStack(alignment: .leading) {
            if taskName.isEmpty {
                Text("Task Name")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.horizontal)
            }
            TextField("", text: $taskName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal)
        }
    }
}

struct TaskDescriptionInput: View {
    @Binding var taskDescription: String

    var body: some View {
        ZStack(alignment: .leading) {
            if taskDescription.isEmpty {
                Text("Task Description (Optional)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.horizontal)
            }
            TextField("", text: $taskDescription)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal)
        }
    }
}

struct TaskDatePicker: View {
    @Binding var taskDate: Date

    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(.red)

            DatePicker("", selection: $taskDate, displayedComponents: .date)
                .labelsHidden()
                .background(Color.red)
                .foregroundColor(.black)
                .accentColor(.black)
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}

struct SubtasksView: View {
    @Binding var subtasks: [DBSubtask]
    @Binding var newSubtask: String // New subtask input binding

    var body: some View {
        VStack(alignment: .leading) {
            Text("Sub-tasks (\(subtasks.filter { $0.isCompleted }.count)/\(subtasks.count))")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)

            ForEach(subtasks) { subtask in
                HStack {
                    Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.white)
                        .onTapGesture {
                            if let index = subtasks.firstIndex(where: { $0.id == subtask.id }) {
                                subtasks[index].isCompleted.toggle()
                            }
                        }

                    Text(subtask.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding()
            }

            HStack {
                TextField("Enter subtask", text: $newSubtask)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)

                Button(action: {
                    addSubtask()
                }) {
                    Text("Add")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }

    private func addSubtask() {
        if !newSubtask.isEmpty {
            let subtask = DBSubtask(id: nil, name: newSubtask, isCompleted: false)
            subtasks.append(subtask)
            newSubtask = ""
        }
    }
}

struct AddTaskViewPreview: View {
    @StateObject private var dbTaskViewModel = DBTaskViewModel()

    var body: some View {
        AddTaskView(dbTaskViewModel: dbTaskViewModel, userId: "exampleUserId")
    }
}

#Preview {
    AddTaskViewPreview()
}



//// MARK: - Add Task View
//struct AddTaskView: View {
//    @ObservedObject var taskViewModel: TaskViewModel
//    @State private var newTask: String = ""
//    @State private var taskDescription: String = ""
//    @State private var taskDate = Date()
//    @State private var subtasks: [Subtask] = []
//    @State private var newSubtask: String = ""
//    
//    @State private var showSuccessMessage: Bool = false
//    @State private var messageOpacity: Double = 0.0
//    
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading, spacing: 16) {
//                TaskNameInput(taskName: $newTask)
//                TaskDescriptionInput(taskDescription: $taskDescription)
//                TaskDatePicker(taskDate: $taskDate)
//                
//                Divider()
//                    .background(Color.white)
//                    .padding(.horizontal)
//                
//                SubtasksView(subtasks: $subtasks, newSubtask: $newSubtask)
//                
//                if showSuccessMessage {
//                    Text("Task created successfully!")
//                        .font(.headline)
//                        .foregroundColor(.green)
//                        .opacity(messageOpacity)
//                        .padding(.horizontal)
//                        .animation(.easeInOut(duration: 0.5), value: messageOpacity)
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    if !newTask.isEmpty {
//                        _ = UserTask(name: newTask, description: taskDescription, date: taskDate, subtasks: subtasks)
//                        taskViewModel.addTask(title: newTask, description: taskDescription, dueDate: taskDate, subtasks: subtasks)
//                        newTask = ""
//                        taskDescription = ""
//                        taskDate = Date()
//                        subtasks = []
//                        showSuccessMessage = true
//                        messageOpacity = 1.0
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            withAnimation {
//                                messageOpacity = 0.0
//                            }
//                        }
//                    }
//                }) {
//                    Text("Create Task")
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(.black)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.red)
//                        .cornerRadius(25)
//                        .padding(.horizontal)
//                }
//            }
//            .padding(.top)
//            .background(Color.black.edgesIgnoringSafeArea(.all))
//            .navigationTitle("Add Task")
//            .navigationBarTitleDisplayMode(.inline)
//            .onDisappear {
//                newTask = ""
//                taskDescription = ""
//                taskDate = Date()
//                subtasks = []
//                messageOpacity = 0.0
//            }
//        }
//    }
//}
//
//
//// MARK: - Task Name Input
//struct TaskNameInput: View {
//    @Binding var taskName: String
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            if taskName.isEmpty {
//                Text("Task Name")
//                    .font(.system(size: 24, weight: .bold))
//                    .foregroundColor(.white.opacity(0.6))
//                    .padding(.horizontal)
//            }
//            TextField("", text: $taskName)
//                .font(.system(size: 24, weight: .bold))
//                .foregroundColor(.white)
//                .padding(.horizontal)
//        }
//    }
//}
//
//// MARK: - Task Description Input
//struct TaskDescriptionInput: View {
//    @Binding var taskDescription: String
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            if taskDescription.isEmpty {
//                Text("Task Description (Optional)")
//                    .font(.system(size: 18, weight: .bold))
//                    .foregroundColor(.white.opacity(0.6))
//                    .padding(.horizontal)
//            }
//            TextField("", text: $taskDescription)
//                .font(.system(size: 18, weight: .bold))
//                .foregroundColor(.white)
//                .padding(.horizontal)
//        }
//    }
//}
//
//// MARK: - Task Date Picker
//struct TaskDatePicker: View {
//    @Binding var taskDate: Date
//    
//    var body: some View {
//        HStack {
//            Image(systemName: "calendar")
//                .foregroundColor(.red)
//            
//            DatePicker("", selection: $taskDate, displayedComponents: .date)
//                .labelsHidden()
//                .background(Color.red)
//                .foregroundColor(.black)
//                .accentColor(.black)
//                .cornerRadius(8)
//        }
//        .padding(.horizontal)
//    }
//}
//
//// MARK: - Subtasks View
//struct SubtasksView: View {
//    @Binding var subtasks: [Subtask]
//    @Binding var newSubtask: String // New subtask input binding
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Sub-tasks (\(subtasks.filter { $0.isCompleted }.count)/\(subtasks.count))")
//                .font(.headline)
//                .foregroundColor(.white)
//                .padding(.horizontal)
//            
//            ForEach(subtasks) { subtask in
//                HStack {
//                    Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
//                        .foregroundColor(.white)
//                        .onTapGesture {
//                            if let index = subtasks.firstIndex(where: { $0.id == subtask.id }) {
//                                subtasks[index].isCompleted.toggle()
//                            }
//                        }
//                    
//                    Text(subtask.name)
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(.white)
//                    
//                    Spacer()
//                }
//                .padding()
//            }
//            
//            HStack {
//                TextField("Enter subtask", text: $newSubtask)
//                    .font(.system(size: 18, weight: .bold))
//                    .foregroundColor(.white)
//                
//                Button(action: {
//                    if !newSubtask.isEmpty {
//                        let subtask = Subtask(name: newSubtask)
//                        subtasks.append(subtask)
//                        newSubtask = ""
//                    }
//                }) {
//                    Text("Add")
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(.red)
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//
//// MARK: - Preview
//struct AddTaskViewPreview: View {
//    @State private var taskViewModel = TaskViewModel()
//    
//    var body: some View {
//        AddTaskView(taskViewModel: taskViewModel)
//    }
//}
//
//#Preview {
//    AddTaskViewPreview()
//}
