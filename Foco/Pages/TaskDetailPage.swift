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
    @State private var emojiText = ""

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var tasks: [TaskItem]
    @State private var emoji = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var title = ""
    @State private var description = ""
    @State private var isRepeated = false
    @State private var errorMessage = ""
    @State private var isDone = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    VStack {

                        EmojiPicker(selectedEmoji: $emoji)
                            }
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...10)
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section {
                    Toggle(isOn: $isRepeated) {
                        Text("Repeat")
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
                
                if !errorMessage.isEmpty {
                    Section(header: Text("Error")) {
                        Text("\(errorMessage)")
                            .foregroundColor(.red)
                    }
                }
                
            }
            .navigationBarTitle("Add fTask", displayMode: .inline)
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
        isRepeated = thisTask.isRepeated
        
    }
    
    func addTask() {
        if checkIsError() {
            return
        }
        
        let newTask = TaskItem(startDate: startDate, endDate: endDate, title: title, desc: description, isRepeated: isRepeated, emoji: emoji, isDone: isDone)
        modelContext.insert(newTask)
        dismiss()
    }
    
    func editTask() {
        if checkIsError() {
            return
        }
        
        let thisTask = self.getExistingTask()
        thisTask.emoji = emoji
        thisTask.title = title
        thisTask.desc = description
        thisTask.startDate = startDate
        thisTask.endDate = endDate
        thisTask.isRepeated = isRepeated
        dismiss()
    }
    
    func deleteTask() {
        let thisTask = self.getExistingTask()
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
        return false
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
            .foregroundColor(.gray)
        }
    }
}
