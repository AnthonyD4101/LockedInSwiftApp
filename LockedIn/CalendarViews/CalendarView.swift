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

// MARK: OLD DATA MODEL IMPLEMENTATION
//struct CalendarView: View {
//    @ObservedObject var taskViewModel = TaskViewModel()
//    @State private var selectedDate = Date()
//    @State private var showAddTaskView = false
//    @State private var selectedTask: UserTask? = nil
//    
//    var body: some View {
//        ZStack {
//            VStack {
//                DatePicker(
//                    "Select a date",
//                    selection: $selectedDate,
//                    displayedComponents: .date
//                )
//                .datePickerStyle(GraphicalDatePickerStyle())
//                .frame(height: UIScreen.main.bounds.height * 0.5)
//                .preferredColorScheme(.dark)
//                .background(Color.black)
//                
//                VStack(alignment: .leading) {
//                    if taskViewModel.tasksFor(date: selectedDate).isEmpty {
//                        Text("No tasks for this date.")
//                            .foregroundColor(.white)
//                            .padding()
//                    } else {
//                        ScrollView {
//                            VStack(alignment: .leading) {
//                                ForEach(taskViewModel.tasksFor(date: selectedDate).indices, id: \.self) { index in
//                                    let taskBinding = $taskViewModel.tasks[taskViewModel.tasks.firstIndex(where: { $0.id == taskViewModel.tasksFor(date: selectedDate)[index].id })!]
//                                    
//                                    // TODO: Remove Test Later
//                                    TestTaskRowView(task: taskBinding) {
//                                        handleTaskCompletion(at: index)
//                                    }
//                                    .padding(.horizontal, 20)
//                                    .padding(.vertical, 10)
//                                    .onTapGesture {
//                                        selectedTask = taskViewModel.tasksFor(date: selectedDate)[index]
//                                    }
//                                    
//                                    Divider()
//                                        .background(Color.white.opacity(0.3))
//                                }
//                            }
//                        }
//                    }
//                }
//                .background(Color.black)
//                .cornerRadius(10)
//                
//                Spacer()
//            }
//            .background(Color.black.edgesIgnoringSafeArea(.all))
//            .foregroundColor(.white)
//            
//            AddTaskButton(showAddTaskView: $showAddTaskView)
//                .padding(.bottom, 40)
//        }
//        .sheet(isPresented: $showAddTaskView) {
//            TestAddTaskView(taskViewModel: taskViewModel)
//                .presentationDetents([.fraction(0.8)])
//        }
//        .sheet(item: $selectedTask) { selectedTask in
//            if let index = taskViewModel.tasks.firstIndex(where: { $0.id == selectedTask.id }) {
//                TestTaskDetailsView(task: $taskViewModel.tasks[index])
//            }
//        }
//    }
//    
//    // MARK: - Handle Task Completion (Task Deletion)
//    private func handleTaskCompletion(at index: Int) {
//        let taskToDelete = taskViewModel.tasksFor(date: selectedDate)[index]
//        if let actualIndex = taskViewModel.tasks.firstIndex(where: { $0.id == taskToDelete.id }) {
//            taskViewModel.tasks.remove(at: actualIndex)
//        }
//    }
//}
//
////TODO: REMOVE LATER
//// MARK: - Add Task View
//struct TestAddTaskView: View {
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
//                TestTaskNameInput(taskName: $newTask)
//                TestTaskDescriptionInput(taskDescription: $taskDescription)
//                TestTaskDatePicker(taskDate: $taskDate)
//
//                Divider()
//                    .background(Color.white)
//                    .padding(.horizontal)
//
//                TestSubtasksView(subtasks: $subtasks, newSubtask: $newSubtask)
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
//struct TestTaskNameInput: View {
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
//struct TestTaskDescriptionInput: View {
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
//struct TestTaskDatePicker: View {
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
//struct TestSubtasksView: View {
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
//#Preview {
//    CalendarView(taskViewModel: TaskViewModel())
//}
