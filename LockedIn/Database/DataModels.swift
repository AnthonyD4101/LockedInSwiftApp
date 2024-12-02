//
//  DataModels.swift
//  LockedIn
//
//  Created by Anthony Delgado on 12/1/24.
//

import SwiftUI
import FirebaseFirestore

struct DBUser: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var username: String
    var password: String
}

struct DBTask: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var date: Date
    var isCompleted: Bool
}

struct DBSubtask: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var isCompleted: Bool
}