//
//  AddTaskView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/21/24.
//

import SwiftUI

struct AddTaskView: View {
    @Binding var tasks: [Task]
    @State private var newTask: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate = Date()
    @State private var subtasks: [String] = []
    @State private var newSubtask: String = ""
    @State private var completedSubtasks: Int = 0
    @State private var isAddingSubtask: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Task Name
                ZStack(alignment: .leading) {
                    if newTask.isEmpty {
                        Text("Task Name")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.horizontal)
                    }
                    TextField("", text: $newTask)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                
                // Task Description
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
                
                // Task Date with Calendar Icon
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
                
                Divider()
                    .background(Color.white)
                    .padding(.horizontal)
                
                // Subtasks Section
                VStack(alignment: .leading) {
                    Text("Sub-tasks (\(completedSubtasks)/\(subtasks.count))")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    // List of Subtasks
                    ForEach(subtasks, id: \.self) { subtask in
                        HStack {
                            Text(subtask)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                if completedSubtasks < subtasks.count {
                                    completedSubtasks += 1
                                }
                            }) {
                                Image(systemName: completedSubtasks >= subtasks.count ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                    }
                    
                    // New Subtask Input
                    if isAddingSubtask {
                        HStack {
                            TextField("Enter subtask", text: $newSubtask)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Button(action: {
                                if !newSubtask.isEmpty {
                                    subtasks.append(newSubtask)
                                    newSubtask = ""
                                    isAddingSubtask = false
                                }
                            }) {
                                Text("Add")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                    }
                    
                    // Add Subtask Button
                    Button(action: {
                        isAddingSubtask.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Subtask")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.red)
                        .padding()
                    }
                }
                
                Spacer()
                
                // Create Task Button
                Button(action: {
                    if !newTask.isEmpty {
                        let task = Task(name: newTask, description: taskDescription, date: taskDate, subtasks: subtasks)
                        tasks.append(task)
                        newTask = ""
                        taskDescription = ""
                        taskDate = Date()
                        subtasks = []
                    }
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
        }
    }
}

struct AddTaskViewPreview: View {
    @State private var tasksPreview: [Task] = []
    
    var body: some View {
        AddTaskView(tasks: $tasksPreview)
    }
}

#Preview {
    AddTaskViewPreview()
}
