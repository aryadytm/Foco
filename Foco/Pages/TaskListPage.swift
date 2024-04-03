import SwiftUI
import SwiftData

struct TaskListPage: View {
    @Query private var taskItems: [TaskItem]
    
    @State private var selectedDate: Date = Date()

    let welcomeName: String = "Arya"
    
    var currentDate: String {
        "It's \(getCurrentDateStr())"
    }
    
    var tasksCompleted: String {
        "\(taskItems.filter { $0.isRepeated && isDateInCurrentWeek($0.startDate) }.count) / \(taskItems.filter { isDateInCurrentWeek($0.startDate) }.count)"
    }
    var distractionTime: String = "0h 0m"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack{
                    ZStack {
                        Image("RectangleInsightBG")
                        Image("Contents")
                            .padding(.top, 40.0)
                    }
                    
                }
                .ignoresSafeArea(.all)
                    .padding(.horizontal)
                VStack {
                        WeekDaysView(selectedDate: $selectedDate)
                    
                    .padding(.leading, 30.0)
                }
    

                HStack{
                    NavigationLink{
                        TaskDetailPage(existingTaskId: "")
                    } label:{
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).foregroundColor(.biru
                            ).frame(maxWidth: .infinity,maxHeight: 50)
                            HStack{
                                Image(systemName: "plus.circle.fill").foregroundColor(.white)
                                Text("Create Task").foregroundColor(.white
                                )
                            }
                        }
                        
                    }
                    .padding(.leading, 30.0)
                }
                .padding(.vertical)

                TasksView(taskItems: getTaskItemsBySelectedDateDay())
            }
            
        }
        Spacer()
        .onAppear {
            
        }
    }
    
    func getTaskItemsBySelectedDateDay() -> [TaskItem] {
        let calendar = Calendar.current
        return taskItems.filter { taskItem in
            let taskStartDate = calendar.startOfDay(for: taskItem.startDate)
            let selectedDateStart = calendar.startOfDay(for: selectedDate)
            return taskStartDate == selectedDateStart
        }
    }
    
    func getCurrentDateStr() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    func isDateInCurrentWeek(_ date: Date) -> Bool {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start,
              let endOfWeek = calendar.date(byAdding: .second, value: -1, to: calendar.dateInterval(of: .weekOfYear, for: Date())!.end) else {
            return false
        }
        return date >= startOfWeek && date <= endOfWeek
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
    @Binding var selectedDate: Date
    
    var selectedDayOfMonth: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: selectedDate)
    }
    
    var days: [Day] {
        var weekDays = [Day]()
        let calendar = Calendar.current
        let today = Date()
        let weekDay = calendar.component(.weekday, from: today)
        
        let daysToAdd = 1 - weekDay
        let startOfWeek = calendar.date(byAdding: .day, value: daysToAdd, to: today)!
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                let weekDayName = calendar.veryShortWeekdaySymbols[i]
                let dayOfMonthInt = calendar.component(.day, from: date)
                weekDays.append(Day(date: date, dayName: weekDayName, dayOfMonthInt: dayOfMonthInt))
            }
        }
        
        return weekDays
    }
    
    var currentDayOfMonth: Int {
        getCurrentDayOfMonth()
    }
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(days.indices, id: \.self) { index in
                    Button {
                        selectedDate = days[index].date
                        print(selectedDate)
                    } label: {
                        VStack {
                            Text(days[index].dayName)
                                .font(.caption)
                                .padding(.bottom, 10)
                                .foregroundColor(days[index].dayOfMonthInt == selectedDayOfMonth ? .blue : .primary)
                            Text(String(days[index].dayOfMonthInt))
                                .fontWeight(.bold)
                                .padding(.top, 10)
                                .padding(.horizontal, 15)
                                .foregroundColor(days[index].dayOfMonthInt == selectedDayOfMonth ? .blue : .primary)
                            

                        }

                    }
                }
                
                
            }
           
        }
        .padding(.bottom)
    }
    
    func getCurrentDayOfMonth() -> Int {
        let today = Date()
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: today)
        return dayOfMonth
    }
    
    struct Day {
        let date: Date
        let dayName: String
        let dayOfMonthInt: Int
    }
}

struct TasksView: View {
    let taskItems: [TaskItem]
    
    var body: some View {
        HStack {
            ScrollView {
                VStack {
                    
                    Text("")
                    
                    if taskItems.isEmpty {
                        VStack {
                            Spacer()
                        }
                        
                        Image("3 1")
                        HStack {
                            Spacer()
                            
                        }
                        VStack{
                            Text("No tasks?")
                            Text("Add a new task to start!")
                        }
                    }
                    
                    ForEach(getTasksSorted(), id: \.self) { item in
                        
                        NavigationLink {
                            TaskDetailPage(existingTaskId: item.id)
                        }
                        label: {
                            TaskItemView(taskItem: item)
                        }
                    }
                    
                    if !taskItems.isEmpty {
                        Spacer()
                    }
                }
            }
        .cornerRadius(20)
        }
    }
    
    func getTasksSorted() -> [TaskItem] {
        return taskItems.sorted { $0.startDate < $1.startDate }
    }
}

struct TaskItemView: View {
    let taskItem: TaskItem
    
    var body: some View {
        HStack {
            ZStack {
                Text(getClock(date: taskItem.startDate))
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
            }
            .frame(width: 70)
            .background(Color.white)
            .cornerRadius(10)
            
            Rectangle()
                .frame(width: 8, height: 50)
                .cornerRadius(2)
                .foregroundColor(taskItem.isRepeated ? Color.green : Color.yellow)
            VStack(alignment: .leading) {
                Text(taskItem.emoji).padding(.horizontal, 10)
                Text(taskItem.title)
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                Text("\(getClock(date: taskItem.startDate)) - \(getClock(date: taskItem.endDate))")
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
    
    func getClock(date: Date) -> String {
        let clockFormatter = DateFormatter()
        clockFormatter.dateFormat = "HH:mm"
        return clockFormatter.string(from: date)
    }
    
}

#Preview {
    TaskListPage()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
