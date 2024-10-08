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
    @State private var errorMessage = ""
    @State private var emoji = "😊"

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    EmojiPicker(selectedEmoji: $emoji)
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...10)
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
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
                
                if !errorMessage.isEmpty {
                    Section(header: Text("Error")) {
                        Text("\(errorMessage)")
                            .foregroundColor(.red)
                    }
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
    
    func getExistingTask() -> TaskItem? {
        let thisTask = tasks.first {
            $0.id == existingTaskId
        }
        return thisTask
    }
    
    func onExistingTaskItem() {
        let thisTask = self.getExistingTask()!
        emoji = thisTask.emoji
        title = thisTask.title
        description = thisTask.desc
        startDate = thisTask.startDate
        endDate = thisTask.endDate
        isDone = thisTask.isDone
        
    }
    
    func addTask() {
        if checkIsError() {
            return
        }
        
        let newTask = TaskItem(startDate: startDate, endDate: endDate, title: title, desc: description, isDone: isDone)
        newTask.emoji = emoji
        
        modelContext.insert(newTask)
        
        dismiss()
    }
    
    func editTask() {
        if checkIsError() {
            return
        }
        
        let thisTask = self.getExistingTask()!
        thisTask.title = title
        thisTask.desc = description
        thisTask.startDate = startDate
        thisTask.endDate = endDate
        thisTask.isDone = isDone
        thisTask.emoji = emoji
        dismiss()
    }
    
    func deleteTask() {
        let thisTask = self.getExistingTask()!
        modelContext.delete(thisTask)
        dismiss()
    }
    
    func checkIsError() -> Bool {
        if title.isEmpty {
            errorMessage = "Title must not be empty!"
            return true
        }
        if startDate >= endDate {
            errorMessage = "End Date must be after Start Date!"
            return true
        }
        
        var activeTask = TaskItem(startDate: startDate, endDate: endDate, title: title, desc: description, isDone: isDone)
        
        var editingTask = self.getExistingTask()
        
        if editingTask != nil {
            activeTask = editingTask!
        }
        
        let overlapTask = activeTask.isTimerangeOverlaps(otherTasks: tasks)
        
        if overlapTask != nil {
            let overlapTaskItem = overlapTask!
            errorMessage = "Your selected time range is already occupied by other task: \(overlapTaskItem.title) (\(overlapTaskItem.getTimerangeStr()))."
            return true
        }
            
        return false
    }
    
}

struct EmojiPicker: View {
    @Binding var selectedEmoji: String
    
    let emojis = ["😊", "😂", "😍", "🥺", "😎", "🤩", "😴", "😡", "🤯", "🥳"]
    
    var body: some View {
        VStack {
            
            Picker("Emoji Tag", selection: $selectedEmoji) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .foregroundColor(.black)
        }
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

