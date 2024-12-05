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
            Form {
                Section(header: Text("Community Details")) {
                    TextField("Community Name", text: $communityName)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    TextField("Image Name (optional)", text: $communityImage)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            .navigationTitle("Add Community")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
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
                    }
                    .disabled(communityName.isEmpty) // Disable if the name is empty
                }
            }
        }
    }
}
