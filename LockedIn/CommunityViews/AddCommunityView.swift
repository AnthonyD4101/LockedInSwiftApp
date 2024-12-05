//
//  AddCommunityView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI

struct AddCommunityView: View {
    @ObservedObject var dbCommunityViewModel: DBCommunityViewModel
    @Environment(\.dismiss) var dismiss

    @State private var communityName: String = ""
    @State private var communityImage: String = "" // Default image name

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Community Name", text: $communityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                TextField("Image Name (optional)", text: $communityImage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                Spacer()

                Button(action: {
                    Task {
                        let newCommunity = DBCommunity(
                            name: communityName,
                            imageName: communityImage.isEmpty ? "swift" : communityImage,
                            tasks: [],
                            resources: [],
                            isFavorite: false,
                            description: [:]
                        )
                        await dbCommunityViewModel.addCommunity(community: newCommunity)
                        
                        await dbCommunityViewModel.fetchCommunities()
                        
                        dismiss()
                    }
                }) {
                    Text("Create Community")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(communityName.isEmpty)
            }
            .padding()
            .navigationTitle("Add Community")
            .navigationBarItems(leading: Button("Cancel") { dismiss() })
        }
    }
}
