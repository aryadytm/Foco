//
//  ProfileModel.swift
//  Foco
//
//  Created by Ahmad Syafiq Kamil on 02/04/24.
//

import Foundation
import SwiftData

@Model
class ProfileModel:Identifiable{
    var id: UUID
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

