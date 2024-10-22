import SwiftUI

struct Community: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct CommunityView: View {
    @State private var selectedCommunity: Community?
    @State private var isShowingDetail = false
    @State private var showAddTaskView = false
    @State private var searchText = ""
    
    let communities = [
        Community(name: "COSC4355", imageName: "swift"),
        Community(name: "Leetcode Study Group", imageName: "brain.head.profile"),
        Community(name: "Data Science Club", imageName: "chart.bar"),
        Community(name: "AI Research Group", imageName: "brain"),
        Community(name: "Mobile Devs", imageName: "iphone"),
        Community(name: "Game Development", imageName: "gamecontroller"),
        Community(name: "Cloud Computing", imageName: "cloud"),
        Community(name: "Cybersecurity Group", imageName: "lock.shield"),
        Community(name: "Web Developers", imageName: "globe"),
        Community(name: "Robotics Team", imageName: "gearshape"),
        Community(name: "Machine Learning Enthusiasts", imageName: "brain.circuit"),
        Community(name: "Blockchain Developers", imageName: "bitcoinsign.circle"),
        Community(name: "Database Administrators", imageName: "server.rack"),
        Community(name: "Open Source Contributors", imageName: "code"),
        Community(name: "Virtual Reality Club", imageName: "gobackward"),
        Community(name: "Linux User Group", imageName: "terminal"),
        Community(name: "Quantum Computing Forum", imageName: "waveform.path.ecg"),
        Community(name: "Competitive Programming", imageName: "trophy"),
        Community(name: "DevOps Engineers", imageName: "hammer"),
        Community(name: "UI/UX Designers", imageName: "paintbrush.pointed")
    ]
    
    var filteredCommunities: [Community] {
        if searchText.isEmpty {
            return communities
        } else {
            return communities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
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
                            if searchText.isEmpty{
                                Text("Search for a community").foregroundColor(Color(red: 0.44, green: 0.46, blue: 0.49))
                            }
                            TextField("", text: $searchText)
                                .foregroundColor(.white)
                                .padding(.leading, 5)
                                .textInputAutocapitalization(.never)
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
                                        Text(community.name)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
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
                CommunityDetailView(community: community)
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
            AddTaskView(tasks: .constant([]))
        }
    }
}

struct CommunityDetailView: View {
    let community: Community
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Back")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.top, -10)
                .padding(.leading)
                
                Spacer()
                
                Text("Details for \(community.name)")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                Spacer()
            }
        }
    }
}

#Preview {
    CommunityView()
}
