//
//  AddCommunityResourceView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI

struct AddCommunityResourceView: View {
    @Binding var community: Community
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var url: String = ""
    
    var body: some View {
        NavigationView {
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
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Add") {
                let newResource = Resource(title: title, url: url)
                community.resources.append(newResource)
                dismiss()
            }.disabled(title.isEmpty || url.isEmpty))
        }
    }
}
