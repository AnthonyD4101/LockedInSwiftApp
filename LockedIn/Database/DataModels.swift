//
//  DataModels.swift
//  LockedIn
//
//  Created by Anthony Delgado on 12/3/24.
//

import SwiftUI
import FirebaseFirestore

struct DBUser: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var username: String
    var password: String
    var statistics: Statistics
    
    init(id: String? = nil, email: String, username: String, password: String, statistics: Statistics = Statistics()) {
        self.id = id
        self.email = email
        self.username = username
        self.password = password
        self.statistics = statistics
    }
}

struct DBTask: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var date: Date
    var isCompleted: Bool
    var subtasks: [DBSubtask]?
}

struct DBSubtask: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var name: String
    var isCompleted: Bool
}

struct Statistics: Codable {
    var totalTasks: Int
    var completedTasks: Int
    var totalSubtasks: Int
    var completedSubtasks: Int
    
    init(totalTasks: Int = 0, completedTasks: Int = 0, totalSubtasks: Int = 0, completedSubtasks: Int = 0) {
        self.totalTasks = totalTasks
        self.completedTasks = completedTasks
        self.totalSubtasks = totalSubtasks
        self.completedSubtasks = completedSubtasks
    }
}
