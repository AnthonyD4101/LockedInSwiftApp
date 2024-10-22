//
//  TaskModel.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/21/24.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var date: Date
    var subtasks: [String] = []
    var isCompleted: Bool = false
}
