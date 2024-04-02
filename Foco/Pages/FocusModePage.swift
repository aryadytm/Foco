//
//  FocusModePage.swift
//  Foco
//
//  Created by Arya Adyatma on 01/04/24.
//

import SwiftUI

struct FocusModePage: View {
    
    @State var focusModeState: FocusModeState = .inProgress
    
    private var currentDate: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM YYYY"
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    @State var taskItem: TaskItem = TaskItem(
        startDate: Calendar.current.date(byAdding: .second, value: 10, to: Date())!,
        endDate: Calendar.current.date(byAdding: .second, value: 20, to: Date())!,
        title: "Study Math",
        desc: "Chapter 5: Vector Spaces",
        isDone: false
    )
    
    @State var taskTimerStr: String = "00:00"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            Text(focusModeState.rawValue)
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
                    
                    Text("Foco Time!")
                        .padding(.top, 12)
                        .padding(.bottom, 2)
                    
                    Text(taskItem.title)
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
                        BottomStateAccomplished(taskItem: $taskItem)
                    } else if focusModeState == .failed {
                        BottomStateFailed(taskItem: $taskItem)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .background(Color.focoBackground)
        }
        .onReceive(timer) { t in
            onTickSecond()
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
                taskItem.isStarted = true
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
            Text("Your time distracted")
                .font(.caption)
            Text(taskItem.getTimeWastedFormatted())
                .fontWeight(.bold)
                .padding(.bottom)
                .foregroundColor(.red)
            
            HStack {
                Button(action: {
                    // TODO: Handle button tap
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
                    // TODO: Handle button tap
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

    var body: some View {
        // Button: Start Now
        VStack {
            Text("Your total time distracted")
                .font(.caption)
            Text(taskItem.getTimeWastedFormatted())
                .fontWeight(.bold)
                .padding(.bottom)
                .foregroundColor(.red)
            
            HStack {
                Button(action: {
                    // TODO: Handle button tap
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

    var body: some View {
        // Button: Start Now
        VStack {
            Text("Your time distracted")
                .font(.caption)
            Text(taskItem.getTimeWastedFormatted())
                .fontWeight(.bold)
                .padding(.bottom)
                .foregroundColor(.red)
            
            HStack {
                Button(action: {
                    // TODO: Handle button tap
                }) {
                    HStack {
                        Text("Next Task")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.focoPrimary)
                    .cornerRadius(10)
                }
                Button(action: {
                    // TODO: Handle button tap
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

#Preview("Incoming") {
    FocusModePage()
}
