//
//  TimerStatusAttributes.swift
//  Foco
//
//  Created by Althaf Nafi Anwar on 01/04/24.
//

import Foundation
import ActivityKit

struct TimerStatusAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        let startTime: Date
    }
}
