import SwiftUI

struct TaskListPage: View {
    let welcomeName: String = "Arya"
    let currentDate: String = "It's Saturday, 23 March"
    let tasksCompleted: String = "27"
    let distractionTime: String = "02:41:36"
    let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Fri", "Sat"]
    let scheduleItems: [ScheduleItemModel] = [
        ScheduleItemModel(time: "09:30", title: "Math: Linear Algebra", duration: "9:30 AM - 11:00 AM"),
        ScheduleItemModel(time: "11:30", title: "Science: Chemistry", duration: "11:30 AM - 1:00 PM"),
        ScheduleItemModel(time: "02:00", title: "History: World War II", duration: "2:00 PM - 3:30 PM")
    ]
//    let taskItems: [TaskItem] = [
//        TaskItem(startDate: Date(), endDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!, title: "Math: Linear Algebra", desc: "Chapter 5: Vector Spaces", isDone: false),
//        TaskItem(startDate: Date(), endDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!, title: "Science: Chemistry", desc: "Lab Experiment: Acids & Bases", isDone: false),
//        TaskItem(startDate: Date(), endDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!, title: "History: World War II", desc: "Lecture on Battle of Stalingrad", isDone: false)
//    ]

    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(welcomeName: welcomeName, currentDate: currentDate)
                .padding(.horizontal)
                .padding(.top)
            CardsView(tasksCompleted: tasksCompleted, distractionTime: distractionTime)
                .padding(.horizontal)
            WeekDaysView(days: days)
                .padding(.horizontal)
            ScheduleView(scheduleItems: scheduleItems)
        }
    }
}

struct HeaderView: View {
    let welcomeName: String
    let currentDate: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome, \(welcomeName)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(currentDate)
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button() {
                
            } label: {
                Text("+")
                    .font(.largeTitle)
                    .frame(width: 40, height: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            
        }
    }
}

struct CardsView: View {
    let tasksCompleted: String
    let distractionTime: String

    var body: some View {
        HStack {
            CardView(textUpper: "Tasks completed this week", textBottom: tasksCompleted)
            CardView(textUpper: "Distraction time this week", textBottom: distractionTime)
        }
        .padding(.vertical)
    }
}


struct CardView: View {
    let textUpper: String
    let textBottom: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(textUpper)
                .font(.headline)
                .foregroundColor(.black.opacity(0.5))
                .padding(.top, 20)
            Text(textBottom)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding(.top, 2)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)

        }
}

struct WeekDaysView: View {
    let days: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(days.indices, id: \.self) { index in
                    VStack {
                        Text(String(index + 1))
                            .fontWeight(.bold)
                            .padding(.top, 10)
                            .padding(.horizontal, 20)
                        Text(days[index])
                            .font(.caption)
                            .padding(.bottom, 10)
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                }
            }
        }
        .padding(.vertical)
    }
}

struct ScheduleView: View {
    let scheduleItems: [ScheduleItemModel]
    
    var body: some View {
        ScrollView {
            VStack {
                
                Text("")
                
                ForEach(scheduleItems, id: \.self) { item in
                    ScheduleItem(time: item.time, title: item.title, duration: item.duration)
                }
                
                Spacer()
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
    }
}

struct ScheduleItem: View {
    let time: String
    let title: String
    let duration: String
    
    var body: some View {
        HStack {
            ZStack {
                Text(time)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
            }
            .frame(width: 70)
            .background(Color.white)
            .cornerRadius(10)
            
            Rectangle()
                .frame(width: 8, height: 50)
                .cornerRadius(2)
                .foregroundColor(Color.green)
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                Text(duration)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct ScheduleItemModel: Identifiable, Hashable {
    let id = UUID()
    let time: String
    let title: String
    let duration: String
}

// Previews
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        TaskListPage()
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(scheduleItems: [
            ScheduleItemModel(time: "9:30", title: "Math: Linear Algebra", duration: "9:30 AM - 11:00 AM")
        ])
    }
}
