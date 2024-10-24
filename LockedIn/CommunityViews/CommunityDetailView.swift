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
    @State private var selectedTask: Task?
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
                                        TaskRowView(task: $task, onComplete: {})
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
                    TaskDetailsView(task: $taskViewModel.tasks[index])
                }
            }
        }
    }
}

