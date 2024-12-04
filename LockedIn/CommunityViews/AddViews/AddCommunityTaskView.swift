//
//  AddCommunityTaskView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI

struct AddCommunityTaskView: View {
    @Binding var community : Community
    @State private var newTask: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate = Date()
    
    //TODO: FIX LATER
    @State private var subtasks: [Subtask] = []
    @State private var dbSubtasks: [DBSubtask] = []
    @State private var newSubtask: String = ""
    
    @State private var showSuccessMessage: Bool = false
    @State private var messageOpacity: Double = 0.0
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                TaskNameInput(taskName: $newTask)
                TaskDescriptionInput(taskDescription: $taskDescription)
                TaskDatePicker(taskDate: $taskDate)
                
                Divider()
                    .background(Color.white)
                    .padding(.horizontal)
                
                // TODO: REMOVE LATER
                //SubtasksView(subtasks: $subtasks, newSubtask: $newSubtask)
                TestSubtasksView(subtasks: $dbSubtasks, newSubtask: $newSubtask)
                
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
                    if !newTask.isEmpty {
                        let task = UserTask(name: newTask, description: taskDescription, date: taskDate, subtasks: subtasks)
                        community.tasks.append(task)
                        newTask = ""
                        taskDescription = ""
                        taskDate = Date()
                        subtasks = []
                        showSuccessMessage = true
                        messageOpacity = 1.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                messageOpacity = 0.0
                            }
                        }
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
            .onDisappear {
                newTask = ""
                taskDescription = ""
                taskDate = Date()
                subtasks = []
                messageOpacity = 0.0
            }
        }
    }
}

struct TestSubtasksView: View {
    @Binding var subtasks: [DBSubtask]
    @Binding var newSubtask: String

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
