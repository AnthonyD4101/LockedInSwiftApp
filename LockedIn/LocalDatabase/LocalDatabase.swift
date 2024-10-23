//
//  LocalDatabase.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/23/24.
//

import Foundation
import GRDB

class DatabaseManager {
    static let shared = DatabaseManager()
    var dbQueue: DatabaseQueue?
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        do {
            // Get path to the documents directory
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dbURL = documentsDirectory.appendingPathComponent("appDatabase.sqlite")
            
            // Create the database queue
            dbQueue = try DatabaseQueue(path: dbURL.path)
            
            try migrator.migrate(dbQueue!)
            print("Database set up at \(dbURL.path)")
        } catch {
            print("Unable to set up database: \(error)")
        }
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createUserTaskSubtaskTables") { db in
            // MARK: User Table
            try db.create(table: "user") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("email", .text).notNull().unique()
                t.column("username", .text).notNull()
                t.column("password", .text).notNull()
            }

            // MARK: Task Table
            try db.create(table: "task") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("userId", .integer).notNull().references("user", onDelete: .cascade)
                t.column("title", .text).notNull()
                t.column("description", .text)
                t.column("dueDate", .text).notNull()
                t.column("isCompleted", .boolean).notNull().defaults(to: false)
            }

            // MARK: Subtasks Table
            try db.create(table: "subtask") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("taskId", .integer).notNull().references("task", onDelete: .cascade)
                t.column("title", .text).notNull()
                t.column("isCompleted", .boolean).notNull().defaults(to: false)
            }
        }

        return migrator
    }
}
