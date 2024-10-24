//
//  ViewModels.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/23/24.
//

import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var users: [User] = []
    
    func signUp(email: String, username: String, password: String) -> Bool {
        if users.contains(where: { $0.email == email || $0.username == username }) {
            return false
        }
        
        let newUser = User(email: email, username: username, password: password)
        users.append(newUser)
        currentUser = newUser
        
        return true
    }
    
    func logIn(email: String, password: String) -> Bool {
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            currentUser = user
            return true
        }
        return false
    }
    
    func updateEmail(newEmail: String) {
        currentUser?.email = newEmail
    }
    
    func updateUsername(newUsername: String) {
        currentUser?.username = newUsername
    }
    
    func updatePassword(currentPassword: String, newPassword: String) -> Bool {
        guard currentUser?.password == currentPassword else {
            return false
        }
        
        currentUser?.password = newPassword
        return true
    }
    
    func logOut() {
        currentUser = nil
    }
}

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    
    func tasksFor(date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func addTask(title: String, description: String, dueDate: Date, subtasks: [Subtask]) {
        let newTask = Task(name: title, description: description, date: dueDate, subtasks: subtasks)
        tasks.append(newTask)
    }
    
    func removeTask(at index: Int) {
        tasks.remove(at: index)
    }
    
    func addSubtask(to task: Task, name: String) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].subtasks.append(Subtask(name: name))
        }
    }
    
    func removeSubtask(from task: Task, at index: Int) {
        if let taskIndex = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[taskIndex].subtasks.remove(at: index)
        }
    }
    
    var totalTasks: Int {
        tasks.count
    }
    
    var completedTasks: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var totalSubtasks: Int {
        tasks.reduce(0) { $0 + $1.subtasks.count }
    }
    
    var completedSubtasks: Int {
        tasks.reduce(0) { $0 + $1.subtasks.filter { $0.isCompleted }.count }
    }
}
