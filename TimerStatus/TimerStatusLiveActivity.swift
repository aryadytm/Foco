//
//  TimerStatusLiveActivity.swift
//  TimerStatus
//
//  Created by Althaf Nafi Anwar on 01/04/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerStatusAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
        var taskName: String
        var timeStart: Date
        var timeEnd: Date
        var timeWastedinSeconds: Float
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TimerStatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerStatusAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimerStatusAttributes {
    fileprivate static var preview: TimerStatusAttributes {
        TimerStatusAttributes(name: "World")
    }
}

extension TimerStatusAttributes.ContentState {
    fileprivate static var smiley: TimerStatusAttributes.ContentState {
        TimerStatusAttributes.ContentState(emoji: "😀", taskName: "A", timeStart: Date(), timeEnd: Date(), timeWastedinSeconds: 65)
     }
     
//     fileprivate static var starEyes: TimerStatusAttributes.ContentState {
//         TimerStatusAttributes.ContentState(emoji: "🤩")
//     }
}

#Preview("Notification", as: .content, using: TimerStatusAttributes.preview) {
   TimerStatusLiveActivity()
} contentStates: {
    TimerStatusAttributes.ContentState.smiley
//    TimerStatusAttributes.ContentState.starEyes
}
