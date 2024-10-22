//
//  TasksView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct TasksView: View {
    @State private var tasks: [Task]
    @State private var showAddTaskView = false
    
    // Initializer to pass sample data for preview
    init(tasks: [Task] = []) {
        _tasks = State(initialValue: tasks)
    }
    
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Today")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .padding(.leading, 20)
                
                Divider()
                    .background(Color.white)
                
                if tasks.isEmpty {
                    Text("No tasks today")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(tasks) { task in
                                VStack(alignment: .leading, spacing: 8) {
                                    // Task Title
                                    Text(task.name)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    // Task Description (optional)
                                    if !task.description.isEmpty {
                                        Text(task.description)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    
                                    // Task Date
                                    Text("Due Date: \(DateFormatter.localizedString(from: task.date, dateStyle: .medium, timeStyle: .none))")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.red)
                                    
                                    Divider()
                                        .background(Color.white.opacity(0.3))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            
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
        .sheet(isPresented: $showAddTaskView) {
            AddTaskView(tasks: $tasks)
                .presentationDetents([.fraction(0.8)])
        }
    }
}

#Preview {
    TasksView(tasks: [
        Task(name: "Sample Task", description: "This is a sample task description.", date: Date())
    ])
}

