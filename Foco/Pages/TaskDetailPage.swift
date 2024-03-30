//
//  TaskDetailPage.swift
//  Foco
//
//  Created by Arya Adyatma on 30/03/24.
//

import SwiftUI

struct TaskDetailPage: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var title = ""
    @State private var description = ""
    @State private var isDone = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section {
                    Toggle(isOn: $isDone) {
                        Text("Completed")
                    }
                }
                
                Section {
                    Button(action: addTodo) {
                        Text("Add Task")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationBarTitle("My Task", displayMode: .inline)
        }
    }
    
    func addTodo() {
        var newTask = TaskItem(startDate: startDate, endDate: endDate, title: title, desc: description, isDone: isDone)
        modelContext.insert(newTask)
        print("Task Added: \(title)")
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    TaskDetailPage()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
