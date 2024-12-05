//
//  AddCommunityResourceView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI

struct AddCommunityResourceView: View {
    var communityId: String
    @ObservedObject var dbCommunityViewModel: DBCommunityViewModel
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var url: String = ""
    @State private var community: DBCommunity?

    var body: some View {
        NavigationView {
            if let community = community {
                Form {
                    Section(header: Text("Resource Title")) {
                        TextField("Enter resource title", text: $title)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }

                    Section(header: Text("Resource URL")) {
                        TextField("Enter resource URL", text: $url)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }
                .navigationBarTitle("Add Resource", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        dismiss()
                    },
                    trailing: Button("Add") {
                        // Add new resource and sync with Firestore
                        var updatedCommunity = community
                        let newResource = DBResource(title: title, url: url)
                        if updatedCommunity.resources == nil {
                            updatedCommunity.resources = []
                        }
                        updatedCommunity.resources?.append(newResource)
                        Task {
                            await dbCommunityViewModel.updateCommunity(community: updatedCommunity)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty || url.isEmpty)
                )
            } else {
                ProgressView("Loading Community...")
            }
        }
        .onAppear {
            loadCommunity()
        }
        .onDisappear(){
            loadCommunity()
        }
    }

    private func loadCommunity() {
        Task {
            self.community = await dbCommunityViewModel.getCommunity(byId: communityId)
        }
    }
}
