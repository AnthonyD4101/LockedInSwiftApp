//
//  CommunityDetailView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI

struct CommunityDetailView: View {
    var communityId: String
    @ObservedObject var dbCommunityViewModel: DBCommunityViewModel
    @ObservedObject var dbTaskViewModel: DBTaskViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab = 0
    @State private var showAddResourceView = false
    @State private var showAddDescriptionView = false
    @State private var showAddTaskView = false
    @State private var community: DBCommunity?
    
    var body: some View {
        VStack(spacing: 16) {
            if let community = community {
                // Header
                CommunityHeaderView(communityName: community.name, dismissAction: { dismiss() })
                
                // Tab Navigation
                CommunityTabNavigationView(selectedTab: $selectedTab)
                
                // Tab Content
                TabView(selection: $selectedTab) {
                    TasksTabView(tasks: community.tasks ?? [])
                        .tag(0)
                    ResourcesTabView(resources: community.resources ?? [])
                        .tag(1)
                    AboutTabView(description: community.description)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding()
                
                // Add Buttons
                HStack {
                    Spacer()
                    Button(action: {
                        handleAddButton()
                    }) {
                        CircleButtonView(icon: "plus", gradient: Gradient(colors: [.blue, .cyan]))
                    }
                }
                .padding()
            } else {
                Text("Loading community...")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            loadCommunity()
        }
        .sheet(isPresented: $showAddTaskView) {
            if let community = community {
                AddCommunityTaskView(communityId: communityId, dbCommunityViewModel: dbCommunityViewModel)
            }
        }
        .sheet(isPresented: $showAddResourceView) {
            if let community = community {
                AddCommunityResourceView(communityId: communityId, dbCommunityViewModel: dbCommunityViewModel)
            }
        }
        .sheet(isPresented: $showAddDescriptionView) {
            if let community = community {
                AddCommunityDescriptionView(communityId: communityId, dbCommunityViewModel: dbCommunityViewModel)
            }
        }
    }
    
    private func handleAddButton() {
        if selectedTab == 0 {
            showAddTaskView = true
        } else if selectedTab == 1 {
            showAddResourceView = true
        } else {
            showAddDescriptionView = true
        }
    }
    
    private func loadCommunity() {
        Task {
            self.community = await dbCommunityViewModel.getCommunity(byId: communityId)
        }
    }
}

struct CommunityHeaderView: View {
    var communityName: String
    var dismissAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: dismissAction) {
                Text("Back")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            Text(communityName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
    }
}

struct CommunityTabNavigationView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            ForEach(0..<3) { index in
                Text(tabTitle(for: index))
                    .font(.headline)
                    .foregroundColor(selectedTab == index ? .white : .gray)
                    .padding()
                    .onTapGesture { selectedTab = index }
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }
    
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Tasks"
        case 1: return "Resources"
        case 2: return "About"
        default: return ""
        }
    }
}

struct TasksTabView: View {
    var tasks: [DBTask]
    
    var body: some View {
        ScrollView {
            if tasks.isEmpty {
                Text("No tasks available")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                ForEach(tasks, id: \.self) { task in
                    CommunityTaskRowView(task: task) {
                        print("\(task.name) completed!") // Handle task completion
                    }
                    
                    Divider().background(Color.white)

                }
            }
        }
        .navigationTitle("Tasks")
    }
}

struct ResourcesTabView: View {
    var resources: [DBResource]
    
    var body: some View {
        ScrollView {
            if resources.isEmpty {
                Text("No resources available")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                ForEach(resources, id: \.self) { resource in
                    if let url = normalizeURL(resource.url), UIApplication.shared.canOpenURL(url) {
                        Link(resource.title, destination: url)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    } else {
                        Text("\(resource.title) (Invalid URL)")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    func normalizeURL(_ urlString: String) -> URL? {
        // Ensure URL has a scheme (e.g., "http://", "https://")
        if let url = URL(string: urlString), url.scheme != nil {
            return url
        } else {
            return URL(string: "https://\(urlString)")
        }
    }
}

struct AboutTabView: View {
    var description: [String: String]
    
    var body: some View {
        ScrollView {
            if description.isEmpty {
                Text("No description available")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                ForEach(description.keys.sorted(), id: \.self) { key in
                    VStack(alignment: .leading) {
                        Text(key)
                            .font(.headline)
                            .foregroundColor(.cyan)
                        
                        Text(description[key] ?? "")
                            .foregroundColor(.white)
                            .padding(.bottom)
                    }
                }
            }
        }
    }
}

struct CircleButtonView: View {
    var icon: String
    var gradient: Gradient
    
    var body: some View {
        Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
            .foregroundColor(.white)
            .padding()
            .background(LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing))
            .clipShape(Circle())
            .shadow(radius: 5)
    }
}

struct CommunityTaskRowView: View {
    var task: DBTask
    var onComplete: () -> Void
    
    var body: some View {
        NavigationLink(destination: TaskDetailView(task: task)) {
            HStack(alignment: .top) {
                Button(action: {
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .red : .white)
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    
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
}

struct TaskDetailView: View {
    var task: DBTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Subtasks for \(task.name)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            if let subtasks = task.subtasks, !subtasks.isEmpty {
                ForEach(subtasks) { subtask in
                    HStack {
                        Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(subtask.isCompleted ? .green : .gray)
                        Text(subtask.name)
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
            } else {
                Text("No subtasks available")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}
