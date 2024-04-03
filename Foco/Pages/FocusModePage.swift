//
//  FocusModePage.swift
//  Foco
//
//  Created by Arya Adyatma on 01/04/24.
//

import SwiftUI
import SwiftData
import ActivityKit


struct FocusModePage: View {
    
    @Query private var taskItems: [TaskItem]
    
//    @State var taskItem: TaskItem?
    
    @State var taskItem: TaskItem = TaskItem(
        startDate: Calendar.current.date(byAdding: .second, value: 10, to: Date())!,
        endDate: Calendar.current.date(byAdding: .second, value: 30, to: Date())!,
        title: "Example Task",
        desc: "Description",
        isDone: false
    )
    
    @State var focusModeState: FocusModeState = .incoming
 
    private var currentDate: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM YYYY"
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    @State var hasNoTasks: Bool = true
    
    func refreshPage() {
        // TODO: Only one task at same time range!
        hasNoTasks = true
        
        guard !taskItems.isEmpty else {
            hasNoTasks = true
            return
        }
        
        // Find the incoming task closest to the current time
        let closestIncomingTask = taskItems.filter {
            Date() < $0.endDate && !$0.isNextTaskClicked
        }.min(by: { $0.endDate.timeIntervalSinceNow < $1.startDate.timeIntervalSinceNow })
        
        
        guard let incomingTask = closestIncomingTask else {
            hasNoTasks = true
            return
        }
        
        taskItem = incomingTask
        
        hasNoTasks = false
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            Text(hasNoTasks ? "Focus Mode" : focusModeState.rawValue)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(currentDate)
                                .padding(.bottom)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .background(Color.focoPrimary)
                    
                    if hasNoTasks {
                        Spacer()
                        ImageStateSet(image: "FocoFocusAccomplished", backgroundColor: Color.gray.opacity(0.2))
                        Text("You have no incoming tasks")
                        Spacer()
                    } else {
                        FocusModeView(taskItem: $taskItem, focusModeState: $focusModeState, refreshFunction: refreshPage)
                    }
                    
                }
            }
            .background(Color.focoBackground)
        }
        .navigationBarHidden(true)
        .onAppear {
            refreshPage()
        }
        
    }
}

struct FocusModeView: View {
    
    @Binding var taskItem: TaskItem
    @Binding var focusModeState: FocusModeState
    let refreshFunction: () -> Void
    
    @Environment(\.scenePhase) var scenePhase

    @State var taskTimerStr: String = "00:00"
    @State var lastBackgroundTimestamp: Int = 0
    @State var isBackground: Bool = false
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var activityManager = FocoLiveActivityManager()
    var hasNoTasks: Bool {
        true
    }
    
    var body: some View {
        VStack {
            
            Text("Foco Time!")
                .padding(.top, 12)
                .padding(.bottom, 2)
            
            Text(taskItem.emoji + " " + taskItem.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 2)
            
            Text(taskItem.getClockStr())
            
            if focusModeState == .incoming {
                ImageStateSet(image: "FocoFocusIncoming", backgroundColor: Color.focoPrimary.opacity(0.1))
            } else if focusModeState == .inProgress {
                ImageStateSet(image: "FocoFocusInProgress", backgroundColor: Color.yellow.opacity(0.2))
            } else if focusModeState == .accomplished {
                ImageStateSet(image: "FocoFocusAccomplished", backgroundColor: Color.green.opacity(0.2))
            } else if focusModeState == .failed {
                ImageStateSet(image: "FocoFocusFailed", backgroundColor: Color.red.opacity(0.2))
            }
            
            Text(focusModeState == .incoming ? "Task Duration" : "Focus Timer")
                .font(.caption)
                .padding(.top, 10)
            
            if focusModeState == .incoming {
                Text(taskItem.getDurationStr())
                    .font(.system(size: 70))
                    .fontWeight(.bold)
                    .padding(.bottom, 1)
                    .opacity(0.7)
            } else if focusModeState == .inProgress {
                Text(taskTimerStr)
                    .font(.system(size: 70))
                    .fontWeight(.bold)
                    .padding(.bottom, 1)
                    .opacity(0.7)
            } else {
                Text("00:00")
                    .font(.system(size: 70))
                    .fontWeight(.bold)
                    .padding(.bottom, 1)
                    .opacity(0.7)
            }
            
            if focusModeState == .incoming {
                BottomStateIncoming(taskItem: $taskItem)
            } else if focusModeState == .inProgress {
                BottomStateInProgress(taskItem: $taskItem)
            } else if focusModeState == .accomplished {
                BottomStateAccomplished(taskItem: $taskItem, refreshFunction: refreshFunction)
            } else if focusModeState == .failed {
                BottomStateFailed(taskItem: $taskItem, refreshFunction: refreshFunction)
            }
            
            Spacer()
        }
        .onAppear {
            focusModeState = taskItem.getFocusModeState()
        }
        .onReceive(timer) { t in
            onTickSecond()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active && lastBackgroundTimestamp > 0 {
                let distractionSecs = Int(Date().timeIntervalSince1970) - lastBackgroundTimestamp
                taskItem.addDistractionTimeSecs(secs: distractionSecs)
                activityManager.stop()
                isBackground = false
            } else if newPhase == .background {
                lastBackgroundTimestamp = Int(Date().timeIntervalSince1970)
                
                if focusModeState == .inProgress {
                    activityManager.start(taskItem: taskItem)
                }
                
                isBackground = true
            }
        }
    }
    
    func onTickSecond() {
//        print("Tick second: \(Date()). isBackground: \(isBackground)")
        focusModeState = taskItem.getFocusModeState()
        taskTimerStr = taskItem.getDurationFromNowStr()
        //        if isBackground {
        //            activityManager.onTickSecond(taskItem: taskItem)
        //        }
    }
    
}

struct ImageStateSet: View {
    var image: String
    var backgroundColor: Color
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .background(Circle().fill(backgroundColor).frame(width: 175, height: 175))
            .padding(.top, 10)
    }
}

struct BottomStateIncoming: View {
    @Binding var taskItem: TaskItem
    @State var taskTimerStr: String = "00:00"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        // Button: Start Now
        VStack {
            Button(action: {
                taskItem.isStartedManually = true
            }) {
                HStack {
                    Image(systemName: "play.fill")
                        .foregroundColor(.white)
                    Text("Start Now!")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.focoPrimary)
                .cornerRadius(10)
            }
            Text("Task will start automatically in **\(taskItem.getDurationUntilStartedStr())**")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .padding(.horizontal, 60)
        }
        .onReceive(timer) { t in
            onTickSecond()
        }
    }
    
    func onTickSecond() {
        taskTimerStr = taskItem.getDurationUntilStartedStr()
    }
    
}

struct BottomStateInProgress: View {
    @Binding var taskItem: TaskItem
    
    var body: some View {
        // Button: Start Now
        VStack {
            TimeDistractedView(taskItem: $taskItem)
            
            HStack {
                Button(action: {
                    taskItem.isDone = true
                }) {
                    HStack {
                        Text("Done!")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.focoPrimary)
                    .cornerRadius(10)
                }
                Button(action: {
                    taskItem.isSurrender = true
                }) {
                    HStack {
                        Text("Surrender :(")
                            .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            Text("Leaving this screen will turn on the Distraction Stopwatch")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .padding(.horizontal, 60)
        }
    }
    
}


struct BottomStateAccomplished: View {
    @Binding var taskItem: TaskItem
    let refreshFunction: () -> Void
    
    var body: some View {
        // Button: Start Now
        VStack {
            TimeDistractedView(taskItem: $taskItem)
            
            HStack {
                Button(action: {
                    taskItem.isNextTaskClicked = true
                    refreshFunction()
                }) {
                    HStack {
                        Text("Next Task")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.focoPrimary)
                    .cornerRadius(10)
                }
                
            }
        }
    }
}


struct BottomStateFailed: View {
    @Binding var taskItem: TaskItem
    let refreshFunction: () -> Void
    
    var body: some View {
        // Button: Start Now
        VStack {
            TimeDistractedView(taskItem: $taskItem)
            
            HStack {
                Button(action: {
                    taskItem.isNextTaskClicked = true
                    refreshFunction()
                }) {
                    HStack {
                        Text("Next Task")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.focoPrimary)
                    .cornerRadius(10)
                }
                if !taskItem.isSurrender {
                    Button(action: {
                        taskItem.isDone = true
                    }) {
                        HStack {
                            Text("Mark as Done")
                                .foregroundColor(.focoPrimary)
                        }
                        .padding()
                        .background(.focoPrimary.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                
            }
            
        }
    }
}


struct TimeDistractedView: View {
    @Binding var taskItem: TaskItem
    
    var body: some View {
        Text("Your time distracted")
            .font(.caption)
        Text(taskItem.getDistractionTimeStr())
            .fontWeight(.bold)
            .padding(.bottom)
            .foregroundColor(getDistractionColor())
    }
    
    func getDistractionColor() -> Color {
        if taskItem.distractionTimeSecs == 0 {
            return Color.green
        } else if taskItem.distractionTimeSecs <= 600 {
            return Color.orange
        }
        return Color.red
    }
}

#Preview("Incoming") {
    FocusModePage()
}
