//
//  FocoWidgetLiveActivity.swift
//  FocoWidget
//
//  Created by Arya Adyatma on 02/04/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FocoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FocoLiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji) \(context.attributes.name)")
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

extension FocoLiveActivityAttributes {
    fileprivate static var preview: FocoLiveActivityAttributes {
        FocoLiveActivityAttributes(name: "World")
    }
}

extension FocoLiveActivityAttributes.ContentState {
    fileprivate static var smiley: FocoLiveActivityAttributes.ContentState {
        FocoLiveActivityAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FocoLiveActivityAttributes.ContentState {
         FocoLiveActivityAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FocoLiveActivityAttributes.preview) {
   FocoWidgetLiveActivity()
} contentStates: {
    FocoLiveActivityAttributes.ContentState.smiley
    FocoLiveActivityAttributes.ContentState.starEyes
}
