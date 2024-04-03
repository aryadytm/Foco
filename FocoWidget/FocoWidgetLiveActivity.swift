//
//  FocoWidgetLiveActivity.swift
//  FocoWidget
//
//  Created by Arya Adyatma on 02/04/24.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct StopwatchText: View {
    var startingSeconds: Int
    
    let now = Date.now
    
    var start: Date {
        Calendar.current.date(byAdding: .second, value: Int(-startingSeconds), to: now)!
    }
    var end: Date {
//        Calendar.current.date(byAdding: .second, value: , to: start)!
        Date.distantFuture
    }

    var body: some View {
        Text(timerInterval: start...end, countsDown: false)
            .foregroundColor(.orange)
        
    }
    
}

struct FocoWidgetLiveActivity: Widget {
    
    func getStopwatch(seconds: Int) -> String {
        return String(seconds)
    }
    
    func getSeconds(seconds: Int) -> Int {
        return 0
    }
    
    func getMinutes(seconds: Int) -> Int {
        return 0
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FocoLiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                HStack {
                    Image("FocoActivityDynamicIsland")
                        .resizable()
                        .frame(width: 110, height: 100)
                        .padding(.top)
                        .padding(.leading)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Spacer()
                        Text("You've wasted")
                        StopwatchText(startingSeconds: context.state.distractionSeconds)
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .frame(width: context.state.distractionSeconds <= 600 ? 90 : 125)
//                        Text("4 minutes")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(.orange)
//                        Text("32 seconds")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(.orange)
                    }
                    .padding(.trailing)
                }
                ProgressView(value: context.state.progress)
                    .tint(.black)
                    .frame(height: 8.0)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .activityBackgroundTint(Color.white.opacity(0.8))
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here. Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image("FocoActivityDynamicIsland")
                        .resizable()
                        .frame(width: 120, height: 110)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Spacer()
                    Text("You've wasted")
                    
                    StopwatchText(startingSeconds: context.state.distractionSeconds)
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .frame(width: 90)
//                    Text("4 minutes")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(.orange)
//                    Text("32 seconds")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(.orange)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(value: context.state.progress)
                        .tint(.white)
                        .frame(height: 8.0)
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .padding(.horizontal)
                    // more content
                }
            } compactLeading: {
                Image("FocoAppIconMini")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .cornerRadius(3.0)
                    .padding(.leading, 10)
            } compactTrailing: {
      
                StopwatchText(startingSeconds: context.state.distractionSeconds)
                    .frame(width: context.state.distractionSeconds < 600 ? 35 : 50)

            } minimal: {
                Image("FocoAppIconMini")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .cornerRadius(3.0)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FocoLiveActivityAttributes {
    fileprivate static var preview: FocoLiveActivityAttributes {
        FocoLiveActivityAttributes()
    }
}

#Preview("Notification", as: .content, using: FocoLiveActivityAttributes.preview) {
    FocoWidgetLiveActivity()
} contentStates: {
    FocoLiveActivityAttributes.ContentState(distractionSeconds: 1, progress: 0.5)
}

#Preview("Expand", as: .dynamicIsland(.expanded), using: FocoLiveActivityAttributes.preview) {
    FocoWidgetLiveActivity()
} contentStates: {
    FocoLiveActivityAttributes.ContentState(distractionSeconds: 1, progress: 0.5)
}

#Preview("Compact", as: .dynamicIsland(.compact), using: FocoLiveActivityAttributes.preview) {
    FocoWidgetLiveActivity()
} contentStates: {
    FocoLiveActivityAttributes.ContentState(distractionSeconds: 1000, progress: 0.5)
}

#Preview("Minimal", as: .dynamicIsland(.minimal), using: FocoLiveActivityAttributes.preview) {
    FocoWidgetLiveActivity()
} contentStates: {
    FocoLiveActivityAttributes.ContentState(distractionSeconds: 1, progress: 0.5)
}

