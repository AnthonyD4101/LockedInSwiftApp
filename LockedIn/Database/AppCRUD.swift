//
//  AppCRUD.swift
//  LockedIn
//
//  Created by Anthony Delgado on 12/3/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// MARK: DB User View Model
class DBUserViewModel: ObservableObject {
    @Published var currentUser: DBUser? = nil
    @Published var isAuthenticated = false
    private let db = Firestore.firestore()
    
    func signUp(email: String, username: String, password: String) async -> Bool {
        do {
            let newUser = DBUser(email: email, username: username, password: password)
            let documentRef = try await db.collection("users").addDocument(from: newUser)
            
            DispatchQueue.main.async {
                self.currentUser = newUser
                self.currentUser?.id = documentRef.documentID
                self.isAuthenticated = true
            }
            print("User signed up successfully.")
            return true
        } catch {
            print("Sign-up error: \(error.localizedDescription)")
            return false
        }
    }
    
    
    func logIn(email: String, password: String) async -> Bool {
        do {
            let querySnapshot = try await db.collection("users")
                .whereField("email", isEqualTo: email)
                .whereField("password", isEqualTo: password)
                .getDocuments()
            
            guard let document = querySnapshot.documents.first else {
                print("Invalid email or password.")
                return false
            }
            
            let userData = try document.data(as: DBUser.self)
            await refreshStatistics()
            
            DispatchQueue.main.async {
                self.currentUser = userData
                self.isAuthenticated = true
            }
            return true
            
        } catch {
            print("Error during login: \(error.localizedDescription)")
            return false
        }
    }
    
    func updateEmail(newEmail: String) async {
        guard let currentUser = currentUser, let userId = currentUser.id else { return }
        do {
            try await db.collection("users").document(userId).updateData(["email": newEmail])
            DispatchQueue.main.async {
                self.currentUser?.email = newEmail
            }
            print("Email updated successfully in Firestore.")
        } catch {
            print("Error updating email: \(error.localizedDescription)")
        }
    }
    
    
    func updateUsername(newUsername: String) async {
        guard let userId = currentUser?.id else { return }
        do {
            try await db.collection("users").document(userId).updateData(["username": newUsername])
            DispatchQueue.main.async {
                self.currentUser?.username = newUsername
            }
        } catch {
            print("Error updating username: \(error.localizedDescription)")
        }
    }
    
    func updatePassword(currentPassword: String, newPassword: String, userId: String) async throws {
        do {
            // Fetch the current user document from Firestore
            let userDocument = try await db.collection("users").document(userId).getDocument()
            
            guard let userData = userDocument.data(),
                  let storedPassword = userData["password"] as? String else {
                throw NSError(domain: "UpdatePassword", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch current password from database."])
            }
            
            // Check if the current password matches the stored password
            if currentPassword != storedPassword {
                throw NSError(domain: "UpdatePassword", code: 2, userInfo: [NSLocalizedDescriptionKey: "Current password is incorrect."])
            }
            
            // Update the password in Firestore
            try await db.collection("users").document(userId).updateData(["password": newPassword])
            
            // Optionally update the local model
            DispatchQueue.main.async {
                self.currentUser?.password = newPassword
            }
            
            print("Password updated successfully.")
        } catch {
            print("Error updating password: \(error.localizedDescription)")
            throw error
        }
    }
    
    func refreshStatistics() async {
        guard let userId = currentUser?.id else { return }
        do {
            let documentSnapshot = try await db.collection("users").document(userId).getDocument()
            
            if let data = documentSnapshot.data(),
               let statisticsData = data["statistics"] as? [String: Any] {
                let statistics = Statistics(
                    totalTasks: statisticsData["totalTasks"] as? Int ?? 0,
                    completedTasks: statisticsData["completedTasks"] as? Int ?? 0,
                    totalSubtasks: statisticsData["totalSubtasks"] as? Int ?? 0,
                    completedSubtasks: statisticsData["completedSubtasks"] as? Int ?? 0
                )
                
                DispatchQueue.main.async {
                    self.currentUser?.statistics = statistics
                }
            }
        } catch {
            print("Error refreshing statistics: \(error.localizedDescription)")
        }
    }
    
    func logOut() {
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isAuthenticated = false
        }
        
        print("User logged out successfully.")
    }
}


// MARK: DB Task View Model
class DBTaskViewModel: ObservableObject {
    @Published var tasks: [DBTask] = []
    private let db = Firestore.firestore()
    
    // MARK: - Task Management
    func fetchTasks(for userId: String) async {
        do {
            let querySnapshot = try await db.collection("users").document(userId).collection("tasks").getDocuments()
            let fetchedTasks = querySnapshot.documents.compactMap { try? $0.data(as: DBTask.self) }
            DispatchQueue.main.async {
                self.tasks = fetchedTasks
            }
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
        }
    }
    
    func addTask(for userId: String, task: DBTask) async {
        do {
            let _ = try await db.collection("users").document(userId).collection("tasks").addDocument(from: task)
            await incrementStatistic(for: userId, field: "totalTasks", value: 1)
            if let subtasks = task.subtasks {
                await incrementStatistic(for: userId, field: "totalSubtasks", value: subtasks.count)
            }
            await fetchTasks(for: userId)
        } catch {
            print("Error adding task: \(error.localizedDescription)")
        }
    }
    
    func updateTask(for userId: String, task: DBTask) async {
        guard let taskId = task.id else { return }
        do {
            try await db.collection("users").document(userId).collection("tasks").document(taskId).setData(from: task)
            await fetchTasks(for: userId)
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }
    
    func removeTask(for userId: String, task: DBTask) async {
        guard let taskId = task.id else { return }
        do {
            try await db.collection("users").document(userId).collection("tasks").document(taskId).delete()
            await decrementStatistic(for: userId, field: "totalTasks", value: 1)
            await incrementStatistic(for: userId, field: "completedTasks", value: 1)
            
            if let subtasks = task.subtasks {
                await decrementStatistic(for: userId, field: "totalSubtasks", value: subtasks.count)
                let completedSubtasks = subtasks.filter { $0.isCompleted }.count
                await incrementStatistic(for: userId, field: "completedSubtasks", value: completedSubtasks)
            }
            await fetchTasks(for: userId)
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }
    
    func addSubtask(to task: DBTask, subtask: DBSubtask, for userId: String) async {
        guard let taskId = task.id else { return }
        do {
            var updatedTask = task
            updatedTask.subtasks = (task.subtasks ?? []) + [subtask]
            try await db.collection("users").document(userId).collection("tasks").document(taskId).setData(from: updatedTask)
            //await incrementStatistic(for: userId, field: "totalSubtasks", value: 1)
            await fetchTasks(for: userId)
        } catch {
            print("Error adding subtask: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Statistics Management
    func incrementStatistic(for userId: String, field: String, value: Int) async {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        do {
            try await userRef.updateData([
                "statistics.\(field)": FieldValue.increment(Int64(value))
            ])
        } catch {
            print("Error incrementing statistic \(field): \(error.localizedDescription)")
        }
    }
    
    func decrementStatistic(for userId: String, field: String, value: Int) async {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        do {
            try await userRef.updateData([
                "statistics.\(field)": FieldValue.increment(Int64(-value))
            ])
        } catch {
            print("Error decrementing statistic \(field): \(error.localizedDescription)")
        }
    }
    
    func tasksFor(date: Date) -> [DBTask] {
        let calendar = Calendar.current
        return tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
}
