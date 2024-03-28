//
//  Item.swift
//  Foco
//
//  Created by Arya Adyatma on 28/03/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
