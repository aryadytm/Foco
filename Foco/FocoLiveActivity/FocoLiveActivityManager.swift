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
    
    func start(taskItem: TaskItem) {
        
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let attributes = FocoLiveActivityAttributes()
                let initialState = FocoLiveActivityAttributes.ContentState(
                    distractionSeconds: taskItem.distractionTimeSecs, progress: taskItem.getProgress()
                )
                
                activity = try Activity.request(
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
        
    }
    
    func onTickSecond(taskItem: TaskItem) {
        let contentState = FocoLiveActivityAttributes.ContentState(
            distractionSeconds: taskItem.distractionTimeSecs, progress: taskItem.getProgress()
        )
        Task {
//            await activity?.update(using: contentState)
            await activity?.update(
                .init(state: contentState, staleDate: nil)
            )
        }
        
    }
    
    func stop() {
        Task {
            for activity in Activity<FocoLiveActivityAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
    
}
