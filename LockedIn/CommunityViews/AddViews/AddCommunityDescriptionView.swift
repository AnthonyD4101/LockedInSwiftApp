//
//  AddCommunityDescriptionView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI

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

