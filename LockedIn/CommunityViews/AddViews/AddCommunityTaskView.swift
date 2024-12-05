//
//  AddCommunityTaskView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI

// MARK: - Add Community Task View
struct AddCommunityTaskView: View {
    var communityId: String
    @ObservedObject var dbCommunityViewModel: DBCommunityViewModel

    @State private var newTaskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate = Date()
    @State private var subtasks: [DBSubtask] = []
    @State private var newSubtaskName: String = ""
    
    @State private var showSuccessMessage: Bool = false
    @State private var messageOpacity: Double = 0.0

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                TaskNameInput(taskName: $newTaskName)
                TaskDescriptionInput(taskDescription: $taskDescription)
                TaskDatePicker(taskDate: $taskDate)
                
                Divider()
                    .background(Color.white)
                    .padding(.horizontal)
                
                SubtasksView(
                    subtasks: $subtasks,
                    newSubtask: $newSubtaskName,
                    onAddSubtask: { subtask in
                        subtasks.append(subtask)
                    }
                )
                
                if showSuccessMessage {
                    Text("Task created successfully!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .opacity(messageOpacity)
                        .padding(.horizontal)
                        .animation(.easeInOut(duration: 0.5), value: messageOpacity)
                }
                
                Spacer()
            }
            .padding(.top)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Add Community Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }, // Cancel button white
                trailing: Button("Add") {
                    createTask()
                    dismiss()
                }
                .disabled(newTaskName.isEmpty) // Disable button if no task name
            )
            .onDisappear {
                resetForm()
            }
        }
    }

    private func createTask() {
        guard !newTaskName.isEmpty else { return }

        let task = DBTask(
            id: nil,
            name: newTaskName,
            description: taskDescription,
            date: taskDate,
            isCompleted: false,
            subtasks: subtasks
        )

        Task {
            let success = await dbCommunityViewModel.addTaskToCommunity(task, toCommunityId: communityId)
            if success {
                resetForm()
                showSuccessMessage = true
                messageOpacity = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        messageOpacity = 0.0
                    }
                }
            } else {
                print("Failed to update the database")
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
