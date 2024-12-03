//
//  TasksView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct TasksView: View {
    @ObservedObject var dbTaskViewModel: DBTaskViewModel
    @ObservedObject var dbUserViewModel: DBUserViewModel
    @State private var showAddTaskView = false
    @State private var selectedTask: DBTask? = nil

    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                TasksHeaderView()

                Divider()
                    .background(Color.white)

                // Filter tasks for the current day
                let dailyTasks = dbTaskViewModel.tasks.filter { task in
                    Calendar.current.isDate(task.date, inSameDayAs: Date())
                }

                if dailyTasks.isEmpty {
                    Text("No tasks today")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(dailyTasks, id: \.id) { task in
                                if let index = dbTaskViewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                    TaskRowView(task: $dbTaskViewModel.tasks[index], onComplete: {
                                        removeTask(task)
                                    })
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

                Spacer()
            }

            AddTaskButton(showAddTaskView: $showAddTaskView)
        }
        .onAppear {
            if let userId = dbUserViewModel.currentUser?.id {
                Task {
                    await dbTaskViewModel.fetchTasks(for: userId)
                }
            }
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

    private func removeTask(_ task: DBTask) {
        if let userId = dbUserViewModel.currentUser?.id {
            Task {
                await dbTaskViewModel.removeTask(for: userId, task: task)
            }
        }
    }
}

struct TasksHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Today")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 40)
                .padding(.leading, 20)
        }
    }
}

struct TaskRowView: View {
    @Binding var task: DBTask
    var onComplete: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                withAnimation {
                    task.isCompleted.toggle()
                    if task.isCompleted {
                        onComplete()
                    }
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .red : .white)
                    .font(.system(size: 20))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(task.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                }

                Text("Due Date: \(DateFormatter.localizedString(from: task.date, dateStyle: .medium, timeStyle: .none))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .background(task.isCompleted ? Color.black.opacity(0.3) : Color.clear)
        .cornerRadius(10)
    }
}

struct AddTaskButton: View {
    @Binding var showAddTaskView: Bool

    var body: some View {
        Button(action: {
            showAddTaskView.toggle()
        }) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
                                           startPoint: .leading,
                                           endPoint: .trailing))
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .frame(width: 60, height: 60)
        .padding()
        .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 200)
    }
}

#Preview {
    let dbTaskViewModel = DBTaskViewModel()
    let dbUserViewModel = DBUserViewModel()

    TasksView(dbTaskViewModel: dbTaskViewModel, dbUserViewModel: dbUserViewModel)
        .environmentObject(dbTaskViewModel)
        .environmentObject(dbUserViewModel)
}



// MARK: OLD DATA MODEL IMPLEMENTATION
//struct TasksView: View {
//    @ObservedObject var taskViewModel: TaskViewModel
//    @State private var showAddTaskView = false
//    @State private var selectedTask: UserTask? = nil
//    
//    var body: some View {
//        ZStack {
//            Color(.black)
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack(alignment: .leading) {
//                TasksHeaderView()
//                
//                Divider()
//                    .background(Color.white)
//                
//                let dailyTasks = taskViewModel.tasksFor(date: Date())
//                
//                if dailyTasks.isEmpty {
//                    Text("No tasks today")
//                        .foregroundColor(.white)
//                        .padding()
//                } else {
//                    ScrollView {
//                        VStack(alignment: .leading) {
//                            ForEach(dailyTasks.indices, id: \.self) { index in
//                                TaskRowView(task: $taskViewModel.tasks[taskViewModel.tasks.firstIndex(where: { $0.id == dailyTasks[index].id })!], onComplete: {
//                                    removeTask(at: taskViewModel.tasks.firstIndex(where: { $0.id == dailyTasks[index].id })!)
//                                })
//                                .padding(.horizontal, 20)
//                                .padding(.vertical, 10)
//                                .onTapGesture {
//                                    selectedTask = dailyTasks[index]
//                                }
//                                
//                                Divider()
//                                    .background(Color.white.opacity(0.3))
//                            }
//                        }
//                    }
//                }
//                
//                Spacer()
//            }
//            
//            AddTaskButton(showAddTaskView: $showAddTaskView)
//        }
//        .sheet(isPresented: $showAddTaskView) {
//            AddTaskView(taskViewModel: taskViewModel)
//                .presentationDetents([.fraction(0.8)])
//        }
//        .sheet(item: $selectedTask) { selectedTask in
//            if let index = taskViewModel.tasks.firstIndex(where: { $0.id == selectedTask.id }) {
//                TaskDetailsView(task: $taskViewModel.tasks[index])
//            }
//        }
//    }
//    
//    private func removeTask(at index: Int) {
//        taskViewModel.removeTask(at: index)
//    }
//}
//
//// MARK: - Tasks Header View
//struct TasksHeaderView: View {
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Today")
//                .font(.system(size: 32, weight: .bold))
//                .foregroundColor(.white)
//                .padding(.top, 40)
//                .padding(.leading, 20)
//        }
//    }
//}
//
//// MARK: - Tasks Row View
//struct TaskRowView: View {
//    @Binding var task: UserTask
//    var onComplete: () -> Void
//    
//    var body: some View {
//        HStack(alignment: .top) {
//            Button(action: {
//                withAnimation {
//                    task.isCompleted.toggle()
//                    if task.isCompleted {
//                        onComplete()
//                    }
//                }
//            }) {
//                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
//                    .foregroundColor(task.isCompleted ? .red : .white)
//                    .font(.system(size: 20))
//            }
//            
//            VStack(alignment: .leading, spacing: 8) {
//                Text(task.name)
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                
//                if !task.description.isEmpty {
//                    Text(task.description)
//                        .font(.system(size: 16, weight: .bold))
//                        .foregroundColor(.white.opacity(0.7))
//                }
//                
//                Text("Due Date: \(DateFormatter.localizedString(from: task.date, dateStyle: .medium, timeStyle: .none))")
//                    .font(.system(size: 16, weight: .bold))
//                    .foregroundColor(.red)
//            }
//            
//            Spacer()
//        }
//        .background(task.isCompleted ? Color.black.opacity(0.3) : Color.clear)
//        .cornerRadius(10)
//    }
//}
//
//// MARK: - Add Task Button
//struct AddTaskButton: View {
//    @Binding var showAddTaskView: Bool
//    
//    var body: some View {
//        Button(action: {
//            showAddTaskView.toggle()
//        }) {
//            Image(systemName: "plus")
//                .resizable()
//                .scaledToFit()
//                .foregroundColor(.white)
//                .padding()
//                .background(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
//                                           startPoint: .leading,
//                                           endPoint: .trailing))
//                .clipShape(Circle())
//                .shadow(radius: 5)
//        }
//        .frame(width: 60, height: 60)
//        .padding()
//        .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 200)
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    TasksView(taskViewModel: TaskViewModel())
//}
