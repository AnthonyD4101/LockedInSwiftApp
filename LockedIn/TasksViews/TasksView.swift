//
//  TasksView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

// MARK: - Tasks View
struct TasksView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var showAddTaskView = false
    @State private var selectedTask: Task? = nil
    
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                TasksHeaderView()
                
                Divider()
                    .background(Color.white)
                
                let dailyTasks = taskViewModel.tasksFor(date: Date())
                
                if dailyTasks.isEmpty {
                    Text("No tasks today")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(dailyTasks.indices, id: \.self) { index in
                                TaskRowView(task: $taskViewModel.tasks[taskViewModel.tasks.firstIndex(where: { $0.id == dailyTasks[index].id })!], onComplete: {
                                    removeTask(at: taskViewModel.tasks.firstIndex(where: { $0.id == dailyTasks[index].id })!)
                                })
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .onTapGesture {
                                    selectedTask = dailyTasks[index]
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.3))
                            }
                        }
                    }
                }
                
                Spacer()
            }
            
            AddTaskButton(showAddTaskView: $showAddTaskView)
        }
        .sheet(isPresented: $showAddTaskView) {
            AddTaskView(taskViewModel: taskViewModel)
                .presentationDetents([.fraction(0.8)])
        }
        .sheet(item: $selectedTask) { selectedTask in
            if let index = taskViewModel.tasks.firstIndex(where: { $0.id == selectedTask.id }) {
                TaskDetailsView(task: $taskViewModel.tasks[index])
            }
        }
    }
    
    private func removeTask(at index: Int) {
        taskViewModel.removeTask(at: index)
    }
}

// MARK: - Tasks Header View
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

// MARK: - Tasks Row View
struct TaskRowView: View {
    @Binding var task: Task
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

// MARK: - Add Task Button
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

// MARK: - Preview
#Preview {
    TasksView(taskViewModel: TaskViewModel())
}
