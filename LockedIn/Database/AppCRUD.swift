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
            // Create user in FirebaseAuth
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let userId = authResult.user.uid

            // Create user in Firestore
            let newUser = DBUser(email: email, username: username, password: password)
            try await db.collection("users").document(userId).setData(from: newUser)

            DispatchQueue.main.async {
                self.currentUser = newUser
                self.isAuthenticated = true
            }
            return true
        } catch let error as NSError {
            print("Sign-up error: \(error.localizedDescription) (\(error.code))")
            return false
        }
    }

    func logIn(email: String, password: String) async -> Bool {
        do {
            // Log in with FirebaseAuth
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let userId = authResult.user.uid

            // Fetch user data from Firestore
            let document = try await db.collection("users").document(userId).getDocument()
            let fetchedUser = try document.data(as: DBUser.self)

            DispatchQueue.main.async {
                self.currentUser = fetchedUser
                self.isAuthenticated = true
            }
            return true
        } catch {
            print("Error logging in: \(error.localizedDescription)")
            return false
        }
    }

    func updateEmail(newEmail: String) async {
        guard let currentUser = currentUser, let userId = currentUser.id else { return }
        do {
            // Update FirebaseAuth email
            try await Auth.auth().currentUser?.updateEmail(to: newEmail)

            // Update Firestore data
            try await db.collection("users").document(userId).updateData(["email": newEmail])
            DispatchQueue.main.async {
                self.currentUser?.email = newEmail
            }
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
    
    // TODO: Check if this works properly
    func updatePassword(newPassword: String) async {
        do {
            try await Auth.auth().currentUser?.updatePassword(to: newPassword)
        } catch {
            print("Error updating password: \(error.localizedDescription)")
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
                self.isAuthenticated = false
            }
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}


// MARK: DB Task View Model
class DBTaskViewModel: ObservableObject {
    @Published var tasks: [DBTask] = []
    private let db = Firestore.firestore()

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
            await fetchTasks(for: userId) // Refresh tasks
        } catch {
            print("Error adding subtask: \(error.localizedDescription)")
        }
    }

    func removeSubtask(from task: DBTask, subtaskId: String, for userId: String) async {
        guard let taskId = task.id else { return }
        do {
            var updatedTask = task
            updatedTask.subtasks = task.subtasks?.filter { $0.id != subtaskId }
            try await db.collection("users").document(userId).collection("tasks").document(taskId).setData(from: updatedTask)
            await fetchTasks(for: userId) // Refresh tasks
        } catch {
            print("Error removing subtask: \(error.localizedDescription)")
        }
    }

    // MARK: Computed Properties
    var totalTasks: Int {
        tasks.count
    }

    var completedTasks: Int {
        tasks.filter { $0.isCompleted }.count
    }

    var totalSubtasks: Int {
        tasks.reduce(0) { $0 + ($1.subtasks?.count ?? 0) }
    }

    var completedSubtasks: Int {
        tasks.reduce(0) { $0 + ($1.subtasks?.filter { $0.isCompleted }.count ?? 0) }
    }

    func tasksFor(date: Date) -> [DBTask] {
        let calendar = Calendar.current
        return tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
}
