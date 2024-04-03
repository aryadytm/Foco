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
    var isRepeated: Bool
    var emoji: String
    var isDone: Bool
    
    init(startDate: Date, endDate: Date, title: String, desc: String, isRepeated: Bool, emoji:String, isDone:Bool) {
        self.id = UUID().uuidString
        self.createdDate = Date.now
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.desc = desc
        self.isRepeated = isRepeated
        self.emoji = emoji
        self.isDone = isDone
    }
}
