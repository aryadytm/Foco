//
//  LiveActivityManager.swift
//  Foco
//
//  Created by Arya Adyatma on 02/04/24.
//

import Foundation
import ActivityKit

class FocoLiveActivityManager {
    
    private var activity: Activity<FocoLiveActivityAttributes>?
    
    func start() {
        var activity: Activity<FocoLiveActivityAttributes>?
        
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let attributes = FocoLiveActivityAttributes(name: "Arya")
                let initialState = FocoLiveActivityAttributes.ContentState(
                    emoji: "EMOJI"
                )
                
                let activity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: initialState, staleDate: nil),
                    pushType: nil
                )
                
            } catch {
                let errorMessage = """
                    Couldn't start activity
                    ------------------------
                    \(String(describing: error))
                    """
                
                print(errorMessage)
            }
        }
        
        self.activity = activity
    }
    
    func stop() {
        Task {
            for activity in Activity<FocoLiveActivityAttributes>.activities {
                let attributes = FocoLiveActivityAttributes(name: "Arya")
                let initialState = FocoLiveActivityAttributes.ContentState(
                    emoji: "EMOJI"
                )
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
    
}
