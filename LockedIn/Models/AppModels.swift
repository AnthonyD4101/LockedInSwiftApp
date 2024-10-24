//
//  AppModels.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/21/24.
//

import SwiftUI

// MARK: - User Model
struct User: Identifiable {
    let id = UUID()
    var email: String
    var username: String
    var password: String
    var tasks: [Task] = []
}

// MARK: - Task Model
struct Task: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var date: Date
    var subtasks: [Subtask] = []
    var isCompleted: Bool = false
}

// MARK: - Subtask Model
struct Subtask: Identifiable {
    let id = UUID()
    let name: String
    var isCompleted: Bool = false
}
