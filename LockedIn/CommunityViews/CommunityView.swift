import SwiftUI

struct Resource: Identifiable {
    let id = UUID()
    var title: String
    var url: String
}
struct Community: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    var tasks: [Task] = []
    var resources: [Resource]
    var isFavorite: Bool = false
    var description: [String: String] = [:]
}


struct CommunityData {
    static var allCommunities: [Community] = [
        Community(
            name: "COSC4355",
            imageName: "swift",
            tasks: [
                Task(
                    name: "Beta App",
                    description: "Views for Beta App",
                    date: Date().addingTimeInterval(86400 * 3),
                    subtasks: ["Community View", "Focus View", "Task View"],
                    isCompleted: false
                ),
                Task(
                    name: "App Specification 2",
                    description: "Fix App Specification to get points back",
                    date: Date().addingTimeInterval(86400 * 5),
                    subtasks: ["Fix Mock UP", "Fix UserFlow", "Write Feedback Response"],
                    isCompleted: false
                )
            ],
            resources: [
                Resource(title: "Official Swift Documentation", url: "https://swift.org/documentation/"),
                Resource(title: "Swift by Sundell", url: "https://www.swiftbysundell.com/")
            ],
            description: [
                "Group Description": "COSC4355 is a student group dedicated to mastering the art of ubiquitous programming, focusing on designing and developing iOS applications. Through a series of hands-on projects, students explore the intricacies of Swift, app architecture, and user experience design.",
                "Purpose": "The primary purpose of this group is to equip students with the skills and knowledge needed to create robust, scalable iOS applications. We emphasize practical learning, real-world problem-solving, and collaboration to prepare students for careers in mobile development.",
                "Values": "• Practical Application Development\n• User-Centered Design\n• Collaborative Learning\n• Continuous Improvement",
                "Goals": "• Develop fully functional iOS applications\n• Master Swift and Xcode tools\n• Implement advanced UI/UX design principles\n• Prepare for professional iOS developer roles"
            ]
        ),
    ]
}


struct CommunityView: View {
    @State private var selectedCommunity: Community?
    @State private var isShowingDetail = false
    @State private var showAddTaskView = false
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    @State private var showAddCommunityView = false
    
    @State private var communities = CommunityData.allCommunities
    
    var filteredCommunities: [Community] {
        let filtered = communities.filter {
            (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)) &&
            (!showFavoritesOnly || $0.isFavorite)
        }
        return filtered
    }
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Communities")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(.white)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(red: 0.12, green: 0.12, blue: 0.12))
                        .frame(height: 45)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                        
                        ZStack {
                            if searchText.isEmpty {
                                Text("Search for a community")
                                    .foregroundColor(Color(red: 0.44, green: 0.46, blue: 0.49))
                            }
                            TextField("", text: $searchText)
                                .foregroundColor(.white)
                                .padding(.leading, 5)
                                .textInputAutocapitalization(.never)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showFavoritesOnly.toggle()
                        }) {
                            Image(systemName: showFavoritesOnly ? "star.fill" : "star")
                                .foregroundColor(showFavoritesOnly ? .yellow : .gray)
                                .padding(.trailing, 10)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if filteredCommunities.isEmpty {
                            Text("No communities found")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .multilineTextAlignment(.center)
                        } else {
                            ForEach(filteredCommunities) { community in
                                Button(action: {
                                    selectedCommunity = community
                                }) {
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text(community.name)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Button(action: {
                                                if let index = communities.firstIndex(where: { $0.id == community.id }) {
                                                    communities[index].isFavorite.toggle()
                                                }
                                            }) {
                                                Image(systemName: community.isFavorite ? "star.fill" : "star")
                                                    .foregroundColor(community.isFavorite ? .yellow : .gray)
                                            }
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 10)
                                        .background(Color(red: 0.247, green: 0.239, blue: 0.239))
                                        
                                        Image(systemName: community.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: .infinity, maxHeight: 150)
                                            .background(
                                                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .top, endPoint: .bottom)
                                            )
                                    }
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .background(Color.black)
                
                Button(action: {
                    showAddCommunityView.toggle()
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
                
                .sheet(isPresented: $showAddCommunityView) {
                    AddCommunityView(communities: $communities)
                }
                
                Spacer()
            }
            .padding()
            .fullScreenCover(item: $selectedCommunity) { community in
                if let communityIndex = communities.firstIndex(where: { $0.id == community.id }) {
                    CommunityDetailView(community: $communities[communityIndex])
                }
            }
        }
    }
}

struct AddCommunityView: View {
    @Binding var communities: [Community]
    @Environment(\.dismiss) var dismiss
    
    @State private var communityName: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Create New Community")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                TextField("Community Name", text: $communityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Spacer()
                
                Button(action: {
                    if !communityName.isEmpty{
                        let newCommunity = Community(
                            name: communityName,
                            imageName: "swift",
                            resources: [],
                            isFavorite: false
                        )
                        communities.append(newCommunity)
                        dismiss()
                    }
                }) {
                    Text("Create Community")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing))
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                }
                .frame(width: 200, height: 60)
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Add Community", displayMode: .inline)
        }
    }
}


struct CommunityDetailView: View {
    @Binding var community: Community
    @Environment(\.dismiss) var dismiss
    
    @State private var showAddTaskView = false
    @State private var showAddResourceView = false
    @State private var showAddDescriptionView = false
    @State private var selectedTask: Task?
    @State private var selectedTab = 0
    
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
            .sheet(item: $selectedTask) { task in
                TaskDetailsView(task: task)
            }
        }
    }
}


struct AddCommunityResourceView: View {
    @Binding var community: Community
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var url: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Resource Title")) {
                    TextField("Enter resource title", text: $title)
                }
                
                Section(header: Text("Resource URL")) {
                    TextField("Enter resource URL", text: $url)
                        .keyboardType(.URL)
                }
            }
            .navigationBarTitle("Add Resource", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Add") {
                let newResource = Resource(title: title, url: url)
                community.resources.append(newResource)
                dismiss()
            }.disabled(title.isEmpty || url.isEmpty))
        }
    }
}

struct AddCommunityDescriptionView: View {
    @Binding var community: Community
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var text: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Description Title")) {
                    TextField("Enter description title", text: $title)
                }
                
                Section(header: Text("Description Text")) {
                    TextEditor(text: $text)
                        .frame(height: 150)
                }
            }
            .navigationBarTitle("Add Description", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Add") {
                community.description[title] = text
                dismiss()
            }.disabled(title.isEmpty || text.isEmpty))
        }
    }
}





struct AddCommunityTaskView: View {
    @Binding var community : Community
    @State private var newTask: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate = Date()
    @State private var subtasks: [String] = []
    @State private var completedSubtasks: Int = 0
    
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
                
                SubtasksView(subtasks: $subtasks, completedSubtasks: $completedSubtasks)
                
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
                        let task = Task(name: newTask, description: taskDescription, date: taskDate, subtasks: subtasks)
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



let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()





#Preview {
    CommunityView()
}
