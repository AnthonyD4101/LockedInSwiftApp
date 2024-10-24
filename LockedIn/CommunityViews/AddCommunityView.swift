//
//  AddCommunityView.swift
//  LockedIn
//
//  Created by Nicholas Tran on 10/24/24.
//

import SwiftUI

struct AddCommunityView: View {
    @Binding var communities: [Community]
    @Environment(\.dismiss) var dismiss
    
    @State private var communityName: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Create New Community")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                TextField("Community Name", text: $communityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Spacer()
                
                Button(action: {
                    if !communityName.isEmpty{
                        let newCommunity = Community(
                            name: communityName,
                            imageName: "swift",
                            resources: [],
                            isFavorite: false
                        )
                        communities.append(newCommunity)
                        dismiss()
                    }
                }) {
                    Text("Create Community")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing))
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                }
                .frame(width: 200, height: 60)
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Add Community", displayMode: .inline)
        }
    }
}
