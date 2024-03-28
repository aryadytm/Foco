import SwiftUI

struct HomePage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HeaderView()
                CardsView()
                WeekDaysView()
                ScheduleView()
            }
            .padding()
        }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome, Arya!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("It's Saturday, 23 March")
                .font(.title3)
                .foregroundColor(.gray)
        }
    }
}

struct CardsView: View {
    var body: some View {
        HStack {
            CardView(textUpper: "Tasks completed this week", textBottom: "27")
            CardView(textUpper: "Distraction time this week", textBottom: "02:41:36")
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
    var dayStr: [String] = ["Sun", "Mon", "Tue", "Wed", "Fri", "Sat"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach([1, 2, 3, 4, 5], id: \.self) { day in
                    VStack {
                        Text(String(day))
                            .fontWeight(.bold)
                            .padding(.top, 10)
                            .padding(.horizontal, 20)
                        Text(dayStr[day])
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
    var body: some View {
        ForEach(0..<5) { _ in
            HStack {
                Rectangle()
                    .frame(width: 4, height: 60)
                    .cornerRadius(2)
                    .foregroundColor(Color.green)
                VStack(alignment: .leading) {
                    Text("9:30")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Math: Linear Algebra")
                        .fontWeight(.bold)
                    Text("9:30 AM - 11:00 AM")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    HomePage()
}
