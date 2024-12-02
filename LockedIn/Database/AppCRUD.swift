//
//  AppCRUD.swift
//  LockedIn
//
//  Created by Anthony Delgado on 12/1/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

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
            let newUser = DBUser(id: userId, email: email, username: username, password: password)
            
            try await db.collection("users").document(userId).setData(from: newUser)
            
            currentUser = newUser
            isAuthenticated = true
            return true
        } catch {
            print("Error signing up: \(error.localizedDescription)")
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
                
                currentUser = try document.data(as: DBUser.self)
                isAuthenticated = true
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
                self.currentUser?.email = newEmail
            } catch {
                print("Error updating email: \(error.localizedDescription)")
            }
        }
        
        func updateUsername(newUsername: String) async {
            guard let userId = currentUser?.id else { return }
            do {
                try await db.collection("users").document(userId).updateData(["username": newUsername])
                currentUser?.username = newUsername
            } catch {
                print("Error updating username: \(error.localizedDescription)")
            }
        }
    
    func logOut() {
            do {
                try Auth.auth().signOut()
                currentUser = nil
                isAuthenticated = false
            } catch {
                print("Error logging out: \(error.localizedDescription)")
            }
        }
}

class DBTaskViewModel: ObservableObject {
    @Published var tasks: [DBTask] = []
    private let db = Firestore.firestore()

    func fetchTasks(for userId: String) async {
        do {
            let querySnapshot = try await db.collection("users").document(userId).collection("tasks").getDocuments()
            tasks = querySnapshot.documents.compactMap { try? $0.data(as: DBTask.self) }
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
        }
    }
    
    func addTask(for userId: String, task: DBTask) async {
            do {
                let _ = try await db.collection("users").document(userId).collection("tasks").addDocument(from: task)
            } catch {
                print("Error adding task: \(error.localizedDescription)")
            }
        }
    
    func updateTask(for userId: String, task: DBTask) async {
        guard let taskId = task.id else { return }
        do {
            try await db.collection("users").document(userId).collection("tasks").document(taskId).setData(from: task)
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }
    
    func removeTask(for userId: String, task: DBTask) async {
        guard let taskId = task.id else { return }
        do {
            try await db.collection("users").document(userId).collection("tasks").document(taskId).delete()
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }


}
