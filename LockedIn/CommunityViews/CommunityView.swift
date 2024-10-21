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
        Community(name: "Robotics Team", imageName: "gearshape")
    ]
    
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
                
                Text("Catch up on anything you might have missed!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(communities) { community in
                            Button(action: {
                                selectedCommunity = community
                            }) {
                                VStack(spacing: 0) {
                                    Text(community.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color.gray)
                                    
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
