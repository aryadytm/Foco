//
//  TaskItem.swift
//  Foco
//
//  Created by Arya Adyatma on 30/03/24.
//

import Foundation
import SwiftData

@Model
class TaskItem {
    var id: String
    var createdDate: Date
    var startDate: Date
    var endDate: Date
    var emoji: String = "😀"
    var title: String
    var desc: String
    var isDone: Bool
    
    var isStartedManually: Bool = false
    var isSurrender: Bool = false
    var isNextTaskClicked = false
    
    var distractionTimeSecs: Int = 0
    
    init(startDate: Date, endDate: Date, title: String, desc: String, isDone: Bool) {
        self.id = UUID().uuidString
        self.createdDate = Date.now
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.desc = desc
        self.isDone = isDone
    }
    
    func getProgress() -> Float {
        let totalSeconds = endDate.timeIntervalSince(startDate)
        let currentTime = Date().timeIntervalSince(startDate)
        let progress = currentTime / totalSeconds
        return max(0.0, Float(progress))
    }
    
    func addDistractionTimeSecs(secs: Int) {
        distractionTimeSecs += secs
    }
    
    func getClockStr() -> String {
        let clockFormatter = DateFormatter()
        clockFormatter.dateFormat = "HH:mm"
        return "\(clockFormatter.string(from: startDate)) - \(clockFormatter.string(from: endDate))"
    }
    
    func getDurationStr() -> String {
        let duration = Int(endDate.timeIntervalSince(startDate))
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = (duration % 3600) % 60
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        }
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func getDurationFromNowStr() -> String {
        let duration = Int(endDate.timeIntervalSince(Date()))
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = (duration % 3600) % 60
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        }
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func getDurationUntilStartedStr() -> String {
        let duration = Int(startDate.timeIntervalSince(Date()))
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = (duration % 3600) % 60
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        }
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func getDistractionTimeStr() -> String {
        let hours = distractionTimeSecs / 3600
        let minutes = (distractionTimeSecs % 3600) / 60
        let seconds = distractionTimeSecs % 60
        if hours == 0 {
            return String(format: "%d minute(s) %d seconds", minutes, seconds)
        }
        return String(format: "%d hour(s) %d minute(s) %d seconds", hours, minutes, seconds)
    }
    
    func getFocusModeState() -> FocusModeState {
        let now = Date()
        if isDone {
            return FocusModeState.accomplished
        }
        if (!isDone && now > endDate) || isSurrender {
            return FocusModeState.failed
        }
        if (now > startDate && now < endDate) || isStartedManually {
            return FocusModeState.inProgress
        }
        if now < startDate {
            return FocusModeState.incoming
        }
        return FocusModeState.incoming
    }
    
    static func getNumberTasksCompletedThisWeek(from tasks: [TaskItem]) -> Int {
        // Define the current date and calendar
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Filter tasks that are completed within this week
        let completedThisWeek = tasks.filter { task in
            let isDone = task.isDone
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            
            return isDone && (task.createdDate >= startOfWeek && task.createdDate < endOfWeek)
        }
        
        // Return the count of tasks
        return completedThisWeek.count
    }
    
    static func getTotalDistractionTimeThisWeekFormatted(from tasks: [TaskItem]) -> String {
        // Define the current date and calendar
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Calculate the total distraction time this week
        let totalDistractionSeconds = tasks.reduce(0) { partialResult, task in
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            
            if task.createdDate >= startOfWeek && task.createdDate < endOfWeek {
                return partialResult + task.distractionTimeSecs
            } else {
                return partialResult
            }
        }
        
        // Convert total distraction time into hours and minutes
        let hours = totalDistractionSeconds / 3600
        let minutes = (totalDistractionSeconds % 3600) / 60
        
        // Return the formatted string
        return "\(hours)h \(minutes)m"
    }
    
    static func getTotalTasksCompletedAllTime(from tasks: [TaskItem]) -> Int {
        // Filter tasks that are marked as done
        let completedTasks = tasks.filter { $0.isDone }
        
        // Return the count of completed tasks
        return completedTasks.count
    }
    
    static func getTotalTasksThisWeek(from tasks: [TaskItem]) -> Int {
        // Define the current date and calendar
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Filter tasks that were created within this week
        let tasksThisWeek = tasks.filter { task in
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            
            return task.createdDate >= startOfWeek && task.createdDate < endOfWeek
        }
        
        // Return the count of tasks
        return tasksThisWeek.count
    }
}

enum FocusModeState : String {
    case incoming = "Incoming"
    case inProgress = "In Progress"
    case accomplished = "Accomplished"
    case failed = "Failed"
}
