import SwiftUI

// Define the Community model
struct Community: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    var tasks: [Task] = []
    var isFavorite: Bool = false
}

// Define a list of communities with 10 entries
struct CommunityData {
    static var allCommunities: [Community] = [
        Community(
            name: "Photography Enthusiasts",
            imageName: "camera",
            tasks: [
                Task(
                    name: "Portrait Photography Workshop",
                    description: "Attend a 2-hour workshop on capturing stunning portraits.",
                    date: Date().addingTimeInterval(86400 * 3),
                    subtasks: ["Register for the workshop", "Bring your camera", "Submit 3 portrait photos"],
                    isCompleted: false
                ),
                Task(
                    name: "Photo Editing Session",
                    description: "Learn advanced photo editing techniques in Lightroom.",
                    date: Date().addingTimeInterval(86400 * 5),
                    subtasks: ["Watch Lightroom tutorial", "Edit 5 photos", "Share your edits"],
                    isCompleted: false
                )
            ]
        ),
        Community(
            name: "Book Club: Sci-Fi Edition",
            imageName: "book",
            tasks: [
                Task(
                    name: "Read Dune",
                    description: "Complete reading Dune by Frank Herbert.",
                    date: Date().addingTimeInterval(86400 * 14),
                    subtasks: ["Read Chapters 1-10", "Read Chapters 11-20", "Join discussion meeting"],
                    isCompleted: false
                ),
                Task(
                    name: "Discussion on Time Travel in Sci-Fi",
                    description: "Participate in the next book club discussion on time travel tropes in sci-fi literature.",
                    date: Date().addingTimeInterval(86400 * 10),
                    subtasks: ["Prepare your thoughts on time travel", "Find examples from books you've read"],
                    isCompleted: false
                )
            ],
            isFavorite: true
        ),
        Community(
            name: "Yoga & Mindfulness Group",
            imageName: "figure.walk",
            tasks: [
                Task(
                    name: "Morning Yoga Routine",
                    description: "Follow a guided yoga routine for beginners.",
                    date: Date().addingTimeInterval(86400),
                    subtasks: ["Watch the tutorial", "Practice poses", "Share your experience in the group"],
                    isCompleted: false
                ),
                Task(
                    name: "Meditation Challenge",
                    description: "Complete a 7-day meditation challenge.",
                    date: Date().addingTimeInterval(86400 * 7),
                    subtasks: ["Meditate for 10 minutes each day", "Log your progress", "Reflect on your experience"],
                    isCompleted: false
                )
            ]
        ),
        Community(
            name: "Creative Writers' Circle",
            imageName: "pencil",
            tasks: [
                Task(
                    name: "Write a Short Story",
                    description: "Write a 1000-word short story on any theme of your choice.",
                    date: Date().addingTimeInterval(86400 * 4),
                    subtasks: ["Choose a theme", "Write the first draft", "Revise and edit"],
                    isCompleted: false
                ),
                Task(
                    name: "Poetry Workshop",
                    description: "Attend the online poetry workshop and create a new poem.",
                    date: Date().addingTimeInterval(86400 * 6),
                    subtasks: ["Register for the workshop", "Brainstorm ideas", "Submit your poem for feedback"],
                    isCompleted: false
                )
            ]
        ),
        Community(
            name: "Tech Innovators Meetup",
            imageName: "desktopcomputer",
            tasks: [
                Task(
                    name: "AI & Machine Learning Seminar",
                    description: "Attend a seminar on AI & Machine Learning advances.",
                    date: Date().addingTimeInterval(86400 * 7),
                    subtasks: ["Register for the event", "Read about AI basics", "Prepare questions for the Q&A"],
                    isCompleted: false
                ),
                Task(
                    name: "Hackathon Preparation",
                    description: "Join the group’s next hackathon preparation session.",
                    date: Date().addingTimeInterval(86400 * 10),
                    subtasks: ["Form a team", "Brainstorm project ideas", "Practice coding challenges"],
                    isCompleted: false
                )
            ]
        ),
        Community(
            name: "Travel Enthusiasts",
            imageName: "airplane",
            tasks: [
                Task(
                    name: "Explore Thailand",
                    description: "Plan a 2-week trip to Thailand.",
                    date: Date().addingTimeInterval(86400 * 30),
                    subtasks: ["Research destinations", "Book flights and accommodations", "Create a travel itinerary"],
                    isCompleted: false
                ),
                Task(
                    name: "Backpacking Tips",
                    description: "Share tips on backpacking for a month in Europe.",
                    date: Date().addingTimeInterval(86400 * 15),
                    subtasks: ["Write a blog post", "Join discussion group", "Prepare a packing list"],
                    isCompleted: false
                )
            ]
        ),
        Community(
            name: "Fitness Warriors",
            imageName: "heart.fill",
            tasks: [
                Task(
                    name: "Strength Training Plan",
                    description: "Follow a 4-week strength training program.",
                    date: Date().addingTimeInterval(86400 * 2),
                    subtasks: ["Download workout plan", "Track your progress", "Share your results with the group"],
                    isCompleted: false
                ),
                Task(
                    name: "Nutrition for Fitness",
                    description: "Learn about nutrition plans for athletes.",
                    date: Date().addingTimeInterval(86400 * 8),
                    subtasks: ["Research meal plans", "Prepare a grocery list", "Discuss with your trainer"],
                    isCompleted: false
                )
            ]
        ),
        Community(
            name: "Board Game Enthusiasts",
            imageName: "gamecontroller",
            tasks: [
                Task(
                    name: "Weekly Board Game Night",
                    description: "Join the weekly board game night at the local café.",
                    date: Date().addingTimeInterval(86400 * 5),
                    subtasks: ["Sign up for the event", "Bring your favorite board game", "Meet new players"],
                    isCompleted: false
                ),
                Task(
                    name: "Learn Strategy Games",
                    description: "Learn and master strategy board games like Catan and Risk.",
                    date: Date().addingTimeInterval(86400 * 10),
                    subtasks: ["Read strategy guides", "Play online versions", "Practice with friends"],
                    isCompleted: false
                )
            ]
        ),
        Community(
            name: "Cycling Adventures",
            imageName: "bicycle",
            tasks: [
                Task(
                    name: "Mountain Biking Tour",
                    description: "Plan a weekend mountain biking tour with the group.",
                    date: Date().addingTimeInterval(86400 * 6),
                    subtasks: ["Choose a route", "Get your bike serviced", "Pack biking essentials"],
                    isCompleted: false
                ),
                Task(
                    name: "Bike Maintenance Workshop",
                    description: "Attend a workshop on basic bike maintenance.",
                    date: Date().addingTimeInterval(86400 * 3),
                    subtasks: ["Register for the workshop", "Bring your bike", "Learn bike repair techniques"],
                    isCompleted: false
                )
            ]
        ),
        Community(
            name: "Film Buffs",
            imageName: "film",
            tasks: [
                Task(
                    name: "Watch Classic Movies",
                    description: "Watch and discuss classic films from the 1950s and 60s.",
                    date: Date().addingTimeInterval(86400 * 4),
                    subtasks: ["Watch 'Casablanca'", "Watch 'Vertigo'", "Prepare for the group discussion"],
                    isCompleted: false
                ),
                Task(
                    name: "Film Editing Workshop",
                    description: "Attend a workshop on video editing for indie filmmakers.",
                    date: Date().addingTimeInterval(86400 * 12),
                    subtasks: ["Sign up for the workshop", "Bring your project", "Submit your edits for review"],
                    isCompleted: false
                )
            ]
        )
    ]
}


struct CommunityView: View {
    @State private var selectedCommunity: Community?
    @State private var isShowingDetail = false
    @State private var showAddTaskView = false
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    
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
                                        .padding(.vertical, 8)
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



struct CommunityDetailView: View {
    @Binding var community: Community
    @Environment(\.dismiss) var dismiss
    
    @State private var showAddTaskView = false
    @State private var selectedTask: Task?
    
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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        if community.tasks.isEmpty {
                            Text("No tasks available")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ForEach($community.tasks) { $task in
                                Button(action: {
                                    selectedTask = task  // Set the selected task
                                }) {
                                    TaskRowView(task: $task, onComplete: {})
                                        .padding(.horizontal)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
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
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .sheet(isPresented: $showAddTaskView) {
                AddCommunityTaskView(community: $community)
            }
            .sheet(item: $selectedTask) { task in
                TaskDetailsView(task: task)
            }
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
