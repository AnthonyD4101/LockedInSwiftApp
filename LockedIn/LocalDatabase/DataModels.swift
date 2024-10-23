//
//  DataModels.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/23/24.
//

import Foundation
import GRDB

// MARK: - User Model
struct User: Codable, FetchableRecord, PersistableRecord, Identifiable {
    var id: Int64?
    var email: String
    var username: String
    var password: String
    
    static let databaseTableName = "User"
    
    init(row: Row) {
        id = row["id"]
        email = row["email"]
        username = row["username"]
        password = row["password"]
    }
    
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["email"] = email
        container["username"] = username
        container["password"] = password
    }
}

// MARK: - Task Model
struct Task: Codable, FetchableRecord, PersistableRecord, Identifiable {
    var id: Int64?
    var userId: Int64
    var title: String
    var description: String?
    var dueDate: String
    var isCompleted: Bool
    
    static let databaseTableName = "Task"
    
    // Custom initializer
    init(id: Int64?, userId: Int64, title: String, description: String?, dueDate: String, isCompleted: Bool) {
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
    
    init(row: Row) {
        id = row["id"]
        userId = row["userId"]
        title = row["title"]
        description = row["description"]
        dueDate = row["dueDate"]
        isCompleted = row["isCompleted"]
    }
    
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["userId"] = userId
        container["title"] = title
        container["description"] = description
        container["dueDate"] = dueDate
        container["isCompleted"] = isCompleted
    }
}

// MARK: - Subtask Model
struct Subtask: Codable, FetchableRecord, PersistableRecord, Identifiable, Equatable {
    var id: Int64?
    var taskId: Int64
    var title: String
    var isCompleted: Bool
    
    static let databaseTableName = "Subtask"
    
    init(row: Row) {
        id = row["id"]
        taskId = row["taskId"]
        title = row["title"]
        isCompleted = row["isCompleted"]
    }
    
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["taskId"] = taskId
        container["title"] = title
        container["isCompleted"] = isCompleted
    }
}
