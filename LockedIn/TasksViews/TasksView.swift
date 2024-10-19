//
//  TasksView.swift
//  LockedIn
//
//  Created by Anthony Delgado on 10/18/24.
//

import SwiftUI

struct TasksView: View {
    @State private var tasks: [String] = []
    @State private var showAddTaskView = false
    
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Today")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .padding(.leading, 20)
                
                Divider()
                    .background(Color.white)
                
                if tasks.isEmpty {
                    Text("No tasks today")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    List(tasks, id: \.self) { task in
                        Text(task)
                            .foregroundColor(.white)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            
            Button(action: {
                showAddTaskView.toggle()
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]),
                                               startPoint: .leading,
                                               endPoint: .trailing))
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .frame(width: 60, height: 60)
            .padding()
            .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 200)
        }
        .sheet(isPresented: $showAddTaskView) {
            AddTaskView(tasks: $tasks)
        }
    }
}

// TODO: Make this separate view
struct AddTaskView: View {
    @Binding var tasks: [String]
    @State private var newTask: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your task", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add Task") {
                    if !newTask.isEmpty {
                        tasks.append(newTask)
                        newTask = ""
                    }
                }
                .padding()
            }
            .navigationTitle("Add Task")
            .navigationBarItems(trailing: Button("Done") {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
        }
    }
}

#Preview {
    TasksView()
}
