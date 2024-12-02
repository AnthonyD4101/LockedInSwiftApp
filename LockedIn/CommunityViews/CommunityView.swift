import SwiftUI

struct CommunityData {
    static var allCommunities: [Community] = [
        Community(
            name: "COSC4355",
            imageName: "swift",
            tasks: [
                UserTask(
                    name: "Beta App",
                    description: "Views for Beta App",
                    date: Date().addingTimeInterval(86400 * 3),
                    subtasks: [
                        Subtask(name: "Community View"),
                        Subtask(name: "Focus View"),
                        Subtask(name: "Task View")
                    ],
                    isCompleted: false
                ),
                UserTask(
                    name: "App Specification 2",
                    description: "Fix App Specification to get points back",
                    date: Date().addingTimeInterval(86400 * 5),
                    subtasks: [
                        Subtask(name: "Fix Mock UP"),
                        Subtask(name: "Fix UserFlow"),
                        Subtask(name: "Write Feedback Response")
                    ],
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
    @ObservedObject var taskViewModel: TaskViewModel
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
                    CommunityDetailView(community: $communities[communityIndex], taskViewModel: taskViewModel)
                }
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
    CommunityView(taskViewModel: TaskViewModel())
}
