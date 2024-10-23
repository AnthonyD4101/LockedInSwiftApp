//
//  TasksView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

// MARK: - Tasks View
struct TasksView: View {
    @State private var tasks: [Task]
    @State private var showAddTaskView = false
    @State private var selectedTask: Task? = nil
    
    init(tasks: [Task] = []) {
        _tasks = State(initialValue: tasks)
    }
    
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                TasksHeaderView()
                
                Divider()
                    .background(Color.white)
                
                if tasks.isEmpty {
                    Text("No tasks today")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(tasks.indices, id: \.self) { index in
                                TaskRowView(task: $tasks[index], onComplete: {
                                    removeTask(at: index)
                                })
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .onTapGesture {
                                    selectedTask = tasks[index]
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
            AddTaskView(tasks: $tasks)
                .presentationDetents([.fraction(0.8)])
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailsView(task: task)
        }
    }
    
    private func removeTask(at index: Int) {
        tasks.remove(at: index)
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
                    // Optional: Check if all subtasks are completed
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
    TasksView(tasks: [
        Task(name: "Sample Task", description: "This is a sample task description.", date: Date(), subtasks: ["Subtask 1", "Subtask 2"])
    ])
}
