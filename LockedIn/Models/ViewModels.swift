//
//  ViewModels.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/23/24.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []

    func tasksFor(date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func addTask(title: String, description: String, dueDate: Date, subtasks: [String]) {
        let newTask = Task(name: title, description: description, date: dueDate, subtasks: subtasks)
        tasks.append(newTask)
    }

    func removeTask(at index: Int) {
        tasks.remove(at: index)
    }
}
