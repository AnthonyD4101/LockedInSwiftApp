//
//  AddCommunityDescriptionView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI

struct AddCommunityDescriptionView: View {
    var communityId: String
    @ObservedObject var dbCommunityViewModel: DBCommunityViewModel
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var text: String = ""
    @State private var community: DBCommunity?

    var body: some View {
        NavigationView {
            if let community = community {
                Form {
                    Section(header: Text("Description Title")) {
                        TextField("Enter description title", text: $title)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }

                    Section(header: Text("Description Text")) {
                        TextEditor(text: $text)
                            .frame(height: 150)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }
                .navigationBarTitle("Add Description", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        dismiss()
                    },
                    trailing: Button("Add") {
                        // Update community description and sync with Firestore
                        var updatedCommunity = community
                        updatedCommunity.description[title] = text
                        Task {
                            await dbCommunityViewModel.updateCommunity(community: updatedCommunity)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty || text.isEmpty)
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
