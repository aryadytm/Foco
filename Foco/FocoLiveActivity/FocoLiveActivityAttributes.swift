//
//  LiveActivityAttributes.swift
//  Foco
//
//  Created by Arya Adyatma on 02/04/24.
//

import ActivityKit


struct FocoLiveActivityAttributes: ActivityAttributes {
    public typealias TimeTrackingStatus = ContentState

    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var distractionSeconds: Int
        var progress: Float
    }
    
    // Fixed non-changing properties about your activity go here!
//    var name: String
}
