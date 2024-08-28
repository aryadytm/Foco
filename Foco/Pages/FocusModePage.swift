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
    
    @State var taskItem: TaskItem = TaskItem(
        startDate: Calendar.current.date(byAdding: .second, value: 10, to: Date())!,
        endDate: Calendar.current.date(byAdding: .second, value: 30, to: Date())!,
        title: "Example Task",
        desc: "Description",
        isDone: false
    )
    
    @State var focusModeState: FocusModeState = .incoming
    @State var hasNoTasks: Bool = true
    
    private var currentDate: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM YYYY"
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    func refreshPage() {
        hasNoTasks = true
        
        guard !taskItems.isEmpty else {
            hasNoTasks = true
            return
        }
        
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
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color.focoBackground.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    VStack {
                        Text(hasNoTasks ? "Focus Mode" : focusModeState.rawValue)
                            .font(.system(size: min(28, geometry.size.width * 0.07)))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(currentDate)
                            .font(.system(size: min(14, geometry.size.width * 0.035)))
                            .padding(.bottom, 5)
                            .foregroundColor(.white)
                    }
                    .frame(width: geometry.size.width)
                    .background(Color.focoPrimary)
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 10) {
                            if hasNoTasks {
                                Spacer(minLength: geometry.size.height * 0.2)
                                ImageStateSet(image: "FocoFocusAccomplished", backgroundColor: Color.gray.opacity(0.2))
                                    .frame(height: geometry.size.height * 0.3)
                                Text("You have no incoming tasks")
                                    .font(.system(size: min(18, geometry.size.width * 0.045)))
                                Spacer()
                            } else {
                                FocusModeView(taskItem: $taskItem, focusModeState: $focusModeState, refreshFunction: refreshPage, geometry: geometry)
                            }
                        }
                        .frame(minHeight: geometry.size.height - 100) // Adjust this value as needed
                    }
                }
            }
        }
        .onAppear {
            refreshPage()
        }
    }
}

struct FocusModeView: View {
    @Binding var taskItem: TaskItem
    @Binding var focusModeState: FocusModeState
    let refreshFunction: () -> Void
    let geometry: GeometryProxy
    
    @Environment(\.scenePhase) var scenePhase
    
    @State var taskTimerStr: String = "00:00"
    @State var lastBackgroundTimestamp: Int = 0
    @State var isBackground: Bool = false
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var activityManager = FocoLiveActivityManager()
    
    var body: some View {
        VStack(spacing: 5) {
            Text("Foco Time!")
                .font(.system(size: min(18, geometry.size.width * 0.045)))
                .padding(.top, 5)
            
            Text(taskItem.emoji + " " + taskItem.title)
                .font(.system(size: min(24, geometry.size.width * 0.06)))
                .fontWeight(.bold)
            
            Text(taskItem.getTimerangeStr())
                .font(.system(size: min(14, geometry.size.width * 0.035)))
            
            Group {
                if focusModeState == .incoming {
                    ImageStateSet(image: "FocoFocusIncoming", backgroundColor: Color.focoPrimary.opacity(0.1))
                } else if focusModeState == .inProgress {
                    ImageStateSet(image: "FocoFocusInProgress", backgroundColor: Color.yellow.opacity(0.2))
                } else if focusModeState == .accomplished {
                    ImageStateSet(image: "FocoFocusAccomplished", backgroundColor: Color.green.opacity(0.2))
                } else if focusModeState == .failed {
                    ImageStateSet(image: "FocoFocusFailed", backgroundColor: Color.red.opacity(0.2))
                }
            }
            .frame(height: geometry.size.height * 0.25)
            
            Text(focusModeState == .incoming ? "Task Duration" : "Focus Timer")
                .font(.system(size: min(14, geometry.size.width * 0.035)))
                .padding(.top, 5)
            
            Group {
                if focusModeState == .incoming {
                    Text(taskItem.getDurationStr())
                } else if focusModeState == .inProgress {
                    Text(taskTimerStr)
                } else {
                    Text("00:00")
                }
            }
            .font(.system(size: min(60, geometry.size.width * 0.15)))
            .fontWeight(.bold)
            .opacity(0.7)
            
            if focusModeState == .incoming {
                BottomStateIncoming(taskItem: $taskItem, geometry: geometry)
            } else if focusModeState == .inProgress {
                BottomStateInProgress(taskItem: $taskItem, geometry: geometry)
            } else if focusModeState == .accomplished {
                BottomStateAccomplished(taskItem: $taskItem, refreshFunction: refreshFunction, geometry: geometry)
            } else if focusModeState == .failed {
                BottomStateFailed(taskItem: $taskItem, refreshFunction: refreshFunction, geometry: geometry)
            }
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
                
                if focusModeState == .inProgress || focusModeState == .failed {
                    taskItem.addDistractionTimeSecs(secs: distractionSecs)
                }
                
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
        focusModeState = taskItem.getFocusModeState()
        taskTimerStr = taskItem.getDurationFromNowStr()
    }
}

struct ImageStateSet: View {
    var image: String
    var backgroundColor: Color
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 150, maxHeight: 150)
            .background(Circle().fill(backgroundColor).frame(width: 130, height: 130))
            .padding(.top, 5)
    }
}

struct BottomStateIncoming: View {
    @Binding var taskItem: TaskItem
    @State var taskTimerStr: String = "00:00"
    let geometry: GeometryProxy
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
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
            Text("Task will start automatically in **\(taskTimerStr)**")
                .font(.system(size: min(12, geometry.size.width * 0.03)))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
                .padding(.horizontal, 30)
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
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            TimeDistractedView(taskItem: $taskItem, geometry: geometry)
            
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
                .font(.system(size: min(12, geometry.size.width * 0.03)))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
                .padding(.horizontal, 30)
        }
    }
}

struct BottomStateAccomplished: View {
    @Binding var taskItem: TaskItem
    let refreshFunction: () -> Void
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            TimeDistractedView(taskItem: $taskItem, geometry: geometry)
            
            Button(action: {
                taskItem.isNextTaskClicked = true
                refreshFunction()
            }) {
                Text("Next Task")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.focoPrimary)
                    .cornerRadius(10)
            }
        }
    }
}

struct BottomStateFailed: View {
    @Binding var taskItem: TaskItem
    let refreshFunction: () -> Void
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            TimeDistractedView(taskItem: $taskItem, geometry: geometry)
            
            HStack {
                Button(action: {
                    taskItem.isNextTaskClicked = true
                    refreshFunction()
                }) {
                    Text("Next Task")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.focoPrimary)
                        .cornerRadius(10)
                }
                if !taskItem.isSurrender {
                    Button(action: {
                        taskItem.isDone = true
                    }) {
                        Text("Mark as Done")
                            .foregroundColor(.focoPrimary)
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
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Text("Your time distracted")
                .font(.system(size: min(12, geometry.size.width * 0.03)))
            Text(taskItem.getDistractionTimeStr())
                .font(.system(size: min(16, geometry.size.width * 0.04)))
                .fontWeight(.bold)
                .padding(.bottom, 5)
                .foregroundColor(getDistractionColor())
        }
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
