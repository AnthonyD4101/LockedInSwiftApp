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
    var tasks: [UserTask] = []
}

// MARK: - Task Model
struct UserTask: Identifiable {
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

// MARK: - Resource Model
struct Resource: Identifiable {
    let id = UUID()
    var title: String
    var url: String
}

// MARK: - Community Model
struct Community: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    var tasks: [UserTask] = []
    var resources: [Resource]
    var isFavorite: Bool = false
    var description: [String: String] = [:]
}

