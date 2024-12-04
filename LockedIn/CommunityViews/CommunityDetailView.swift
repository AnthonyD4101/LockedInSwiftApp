//
//  CommunityDetailView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI

struct CommunityDetailView: View {
    @Binding var community: Community
    @Environment(\.dismiss) var dismiss
    
    @State private var showAddTaskView = false
    @State private var showAddResourceView = false
    @State private var showAddDescriptionView = false
    @State private var selectedTask: UserTask?
    @State private var selectedTab = 0
    
    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Back")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                
                HStack {
                    Text(community.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    Spacer()
                }
                
                Divider()
                    .background(Color.white)
                
                
                HStack {
                    if selectedTab > 0 {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Text("Previous")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 100, alignment: .leading)
                    } else {
                        Spacer().frame(width: 100)
                    }
                    
                    Spacer()
                    
                    Text(selectedTab == 0 ? "Tasks" : selectedTab == 1 ? "Resources" : "About")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    if selectedTab < 2 {
                        HStack {
                            Text("Next")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 100, alignment: .trailing)
                    } else {
                        Spacer().frame(width: 100)
                    }
                }
                
                TabView(selection: $selectedTab) {
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            if community.tasks.isEmpty {
                                Text("No tasks available")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                ForEach($community.tasks) { $task in
                                    Button(action: {
                                        selectedTask = task
                                    }) {
                                        OLDTaskRowView(task: $task, onComplete: {})
                                            .padding(.horizontal)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding(.leading)
                    }.tag(0)
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            if community.resources.isEmpty {
                                Text("No resources available")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                ForEach(community.resources) { resource in
                                    Link(destination: URL(string: resource.url)!) {
                                        Text(resource.title)
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                            .underline()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.leading)
                    }.tag(1)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            if community.description.isEmpty {
                                Text("No information available")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            else {
                                ForEach(community.description.keys.sorted(), id: \.self) { title in
                                    Text(title)
                                        .font(.headline)
                                        .foregroundColor(.cyan)
                                    
                                    Text(community.description[title] ?? "")
                                        .foregroundColor(.white)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }.tag(2)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer()
                
                Button(action: {
                    if selectedTab == 0 {
                        showAddTaskView.toggle()
                    } else if (selectedTab == 1) {
                        showAddResourceView.toggle()
                    } else if (selectedTab == 2) {
                        showAddDescriptionView.toggle()
                    }
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
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .sheet(isPresented: $showAddTaskView) {
                AddCommunityTaskView(community: $community)
            }
            .sheet(isPresented: $showAddResourceView) {
                AddCommunityResourceView(community: $community)
            }
            .sheet(isPresented: $showAddDescriptionView) {
                AddCommunityDescriptionView(community: $community)
            }
            .sheet(item: $selectedTask) { selectedTask in
                if let index = taskViewModel.tasks.firstIndex(where: { $0.id == selectedTask.id }) {
                    OLDTaskDetailsView(task: $taskViewModel.tasks[index])
                }
            }
        }
    }
}

// FOR TESTING ONLY, CHANGE LATER
struct OLDTaskDetailsView: View {
    @Binding var task: UserTask
    @State private var subtasks: [Subtask]
    
    init(task: Binding<UserTask>) {
        self._task = task
        self._subtasks = State(initialValue: task.wrappedValue.subtasks)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                TaskNameView(name: task.name)
                TaskDescriptionView(description: task.description)
                TaskDueDateView(date: task.date)
                
                Divider()
                    .background(Color.white)
                    .padding(.horizontal)
                
                OLDSubtasksListView(subtasks: $subtasks)
                
                if subtasks.allSatisfy({ $0.isCompleted }) && !subtasks.isEmpty {
                    HStack {
                        Spacer()
                        CompleteTaskButton {
                            print("Task completed!")
                        }
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
                
                Spacer()
            }
            .padding(.top)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                task.subtasks = subtasks
            }
        }
    }
}

// FOR TESTING ONLY, CHANGE LATER
struct OLDTaskRowView: View {
    @Binding var task: UserTask
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

// FOR TESTING ONLY, CHANGE LATER
struct OLDSubtasksListView: View {
    @Binding var subtasks: [Subtask]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sub-tasks (\(subtasks.filter { $0.isCompleted }.count)/\(subtasks.count))")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ForEach($subtasks) { $subtask in
                HStack {
                    Button(action: {
                        subtask.isCompleted.toggle()
                    }) {
                        Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.white)
                    }
                    
                    Text(subtask.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}
