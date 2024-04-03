import SwiftUI
import SwiftData

struct TaskListPage: View {
    @Query private var taskItems: [TaskItem]
    
    @State private var selectedDate: Date = Date()
    
    let welcomeName: String = "Arya"
    
    var currentDate: String {
        "Today is \(getCurrentDateStr())"
    }
    
    var distractionTime: String = "0h 0m"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    VStack {
                        Image("FocoLogo")
                            .padding()
                            .padding(.bottom, 10)
                    }
                    Spacer()
                }
                .background(Color.focoPrimary)
                
                VStack {
                    WeekDaysView(selectedDate: $selectedDate)
                        .padding(.top)
                        .padding(.leading)
                    Text(currentDate)
                        .font(.subheadline)
                        .padding(.bottom)
                }
                .background(Color.white)
                
                
                HStack{
                    NavigationLink{
                        TaskDetailPage(existingTaskId: "")
                    } label:{
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).foregroundColor(.focoPrimary
                            ).frame(maxWidth: .infinity,maxHeight: 50)
                            HStack{
                                Image(systemName: "plus.circle.fill").foregroundColor(.white)
                                Text("New Task").foregroundColor(.white
                                )
                            }
                        }
                    }
                }
                .padding()
                
                TasksView(taskItems: getTaskItemsBySelectedDateDay())
            }
            .background(Color.focoBackground)
        }
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
        dateFormatter.dateFormat = "EEEE, d MMMM YYYY"
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
                                .foregroundColor(.primary)
                            Text(String(days[index].dayOfMonthInt))
//                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .foregroundColor(days[index].dayOfMonthInt == selectedDayOfMonth ? .white : .primary)
                                .background(days[index].dayOfMonthInt == selectedDayOfMonth ? .focoPrimary : .white)
                                .cornerRadius(100)
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
                .foregroundColor(Color.green)
            VStack(alignment: .leading) {
                Text(taskItem.emoji + " " + taskItem.title)
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
