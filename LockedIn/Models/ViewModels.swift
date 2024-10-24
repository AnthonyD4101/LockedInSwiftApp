//
//  ViewModels.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/23/24.
//

import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    
    func logIn(email: String, password: String) -> Bool {
        let exampleUser = User(email: "User@example.com", username: "exampleUser", password: "Password123")
        
        if email == exampleUser.email && password == exampleUser.password {
            currentUser = exampleUser
            return true
        }
        
        return false
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
}
