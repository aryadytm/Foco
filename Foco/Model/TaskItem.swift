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
    var title: String
    var desc: String
    var isDone: Bool
    
    var isStarted: Bool = false
    var emoji: String = "😀"
    var timeWastedSeconds: Int = 0
    
    
    init(startDate: Date, endDate: Date, title: String, desc: String, isDone: Bool) {
        self.id = UUID().uuidString
        self.createdDate = Date.now
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.desc = desc
        self.isDone = isDone
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
    
    func getTimeWastedFormatted() -> String {
        let hours = timeWastedSeconds / 3600
        let minutes = (timeWastedSeconds % 3600) / 60
        let seconds = (timeWastedSeconds % 3600) % 60
        if hours == 0 {
            return String(format: "%02d minutes %02d seconds", minutes, seconds)
        }
        return String(format: "%02d hour(s) %02d seconds %02 minutes", hours, minutes, seconds)

    }
    
    func getFocusModeState() -> FocusModeState {
        let now = Date()
        if isDone {
            return FocusModeState.accomplished
        }
        if !isDone && now > endDate {
            return FocusModeState.failed
        }
        if now < startDate {
            return FocusModeState.incoming
        }
        if (now > startDate && now < endDate) || isStarted {
            return FocusModeState.inProgress
        }
        return FocusModeState.incoming
    }
}

enum FocusModeState : String {
    case incoming = "Incoming"
    case inProgress = "In Progress"
    case accomplished = "Accomplished"
    case failed = "Failed"
}
