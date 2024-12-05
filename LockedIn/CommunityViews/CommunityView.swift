//
//  CommunityView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI
struct CommunityView: View {
    @ObservedObject var dbCommunityViewModel: DBCommunityViewModel
    @ObservedObject var dbTaskViewModel: DBTaskViewModel

    @State private var selectedCommunityId: String?
    @State private var isShowingDetail = false
    @State private var showAddTaskView = false
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    @State private var showAddCommunityView = false
    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass

    var filteredCommunities: [DBCommunity] {
        dbCommunityViewModel.communities.filter {
            (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)) &&
            (!showFavoritesOnly || $0.isFavorite)
        }
    }

    var body: some View {
        let orientation = DeviceOrientation(
            widthSizeClass: widthSizeClass,
            heightSizeClass: heightSizeClass
        )

        let isLandscape = orientation.isLandscape(device: .iPhonePlusOrMax) || orientation.isLandscape(device: .iPhone) || orientation.isLandscape(device: .iPadFull)

        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 20) {
                Text("Communities")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, isLandscape ? 100 : 50)
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
                                    selectedCommunityId = community.id
                                }) {
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text(community.name)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)

                                            Button(action: {
                                                Task {
                                                    var updatedCommunity = community
                                                    updatedCommunity.isFavorite.toggle()
                                                    await dbCommunityViewModel.updateCommunity(community: updatedCommunity)
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
                .frame(maxWidth: 600, minHeight: isLandscape ? 140 : 400)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .sheet(isPresented: $showAddCommunityView) {
                    AddCommunityView(dbCommunityViewModel: dbCommunityViewModel)
                }
                .padding(25)
                .padding(.bottom, isLandscape ? 150 : 0)
            }
            .padding()
            .fullScreenCover(item: $selectedCommunityId) { communityId in
                CommunityDetailView(
                    communityId: communityId,
                    dbCommunityViewModel: dbCommunityViewModel,
                    dbTaskViewModel: dbTaskViewModel
                )
            }
        }
        .onAppear {
            Task {
                await dbCommunityViewModel.fetchCommunities()
            }
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

extension String: Identifiable {
    public var id: String { self }
}
