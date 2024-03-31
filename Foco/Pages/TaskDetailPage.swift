//
//  TaskDetailPage.swift
//  Foco
//
//  Created by Arya Adyatma on 30/03/24.
//

import SwiftUI
import SwiftData

struct TaskDetailPage: View {
    var existingTaskId: String = ""
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var tasks: [TaskItem]

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
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section {
                    Toggle(isOn: $isDone) {
                        Text("Completed")
                    }
                }
                
                if existingTaskId.isEmpty {
                    Section {
                        Button(action: addTask) {
                            Text("Add Task")
                                .frame(maxWidth: .infinity)
                        }
                    }
                } else {
                    Section {
                        Button(action: editTask) {
                            Text("Edit Task")
                                .frame(maxWidth: .infinity)
                        }
                        Button(action: deleteTask) {
                            Text("Delete Task")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.red)
                        }
                    }.listRowSeparator(.hidden)
                }
            }
            .navigationBarTitle("Task", displayMode: .inline)
            .onAppear {
                if !existingTaskId.isEmpty {
                    onExistingTaskItem()
                }
            }
        }
    }
    
    func getExistingTask() -> TaskItem {
        let thisTask = tasks.first {
            $0.id == existingTaskId
        }!
        return thisTask
    }
    
    func onExistingTaskItem() {
        let thisTask = self.getExistingTask()
        title = thisTask.title
        description = thisTask.desc
        startDate = thisTask.startDate
        endDate = thisTask.endDate
        isDone = thisTask.isDone
        
    }
    
    func addTask() {
        let newTask = TaskItem(startDate: startDate, endDate: endDate, title: title, desc: description, isDone: isDone)
        modelContext.insert(newTask)
        dismiss()
    }
    
    func editTask() {
        // TODO
        
    }
    
    func deleteTask() {
        let thisTask = self.getExistingTask()
        modelContext.delete(thisTask)
        dismiss()
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
