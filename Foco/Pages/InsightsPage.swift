//
//  ProfilePage.swift
//  Foco
//
//  Created by Arya Adyatma on 01/04/24.
//

import SwiftUI
import SwiftData

struct InsightsPage: View {
    @State private var keepScreenOn = false
    
    @Query private var taskItems: [TaskItem]
    @Query private var users: [ProfileModel]
    
    var numCompletedTasksAllTime: Int {
        TaskItem.getTotalTasksCompletedAllTime(from: taskItems)
    }
    
    var numTasksCompletedThisWeek: Int {
        TaskItem.getNumberTasksCompletedThisWeek(from: taskItems)
    }
    
    var numTasksThisWeek: Int {
        TaskItem.getTotalTasksThisWeek(from: taskItems)
    }
    
    var totalDistractionTimeThisWeek: String {
        TaskItem.getTotalDistractionTimeThisWeekFormatted(from: taskItems)
    }
    
    var user: ProfileModel {
        if users.isEmpty {
            return ProfileModel(name: "Arya Adyatma")
        }
        return users.first!
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        VStack {
                            Text("Insights")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom)
                        }
                        Spacer()
                    }
                    .background(Color.focoPrimary)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Profile Image and Greeting
                            HStack(alignment: .top) {
//                                Image(systemName: "person.circle")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 70, height: 70)
//                                    .clipShape(Circle())
//                                    .padding(.top, 8)
//                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                
                                VStack(alignment: .leading) {
                                    Text("Hi, \(user.name)!")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("You have completed **\(numCompletedTasksAllTime) tasks** since using this app.")
                                        .padding(.top, 1)
                                }
                                .padding(.top, 8)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            // Task and Distraction Stats
                            HStack(spacing: 20) {
                                StatisticView(title: "Tasks completed\nthis week", value: "\(numTasksCompletedThisWeek) / \(numTasksThisWeek)")
                                    .background(Color.white)
                                    .cornerRadius(10)
                                StatisticView(title: "Distraction time\nthis week", value: "\(totalDistractionTimeThisWeek)")
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }
                   
                            
                            // Settings
                            VStack(spacing: 10) {
                                NavigationLink(destination: Text("Coming Soon!")) {
                                    SettingRow(title: "Whitelist Apps", iconName: "chevron.right")
                                }
                                
                                Toggle(isOn: $keepScreenOn) {
                                    Text("Keep Screen On")
                                }
                                .padding()
                                
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            // Settings
                            VStack(spacing: 10) {
                                NavigationLink(destination: AboutPage()) {
                                    SettingRow(title: "About", iconName: "chevron.right")
                                }
                                
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .padding()
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
        }
    }
}

struct StatisticView: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 1)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SettingRow: View {
    var title: String
    var iconName: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: iconName)
        }
        .padding()
    }
}

#Preview {
    InsightsPage()
}
