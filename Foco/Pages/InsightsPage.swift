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
    @State private var showingClearDataAlert = false
    
    @Query private var taskItems: [TaskItem]
    @Query private var users: [ProfileModel]
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
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
                                }.foregroundColor(.black)
                                
                                Toggle(isOn: $keepScreenOn) {
                                    Text("Keep Screen On")
                                }.foregroundColor(.black)
                                    .padding()
                                
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            // Settings
                            VStack(spacing: 10) {
                                NavigationLink(destination: AboutPage()) {
                                    SettingRow(title: "About", iconName: "chevron.right")
                                }.foregroundColor(.black)
                                
                                Button {
                                    showingClearDataAlert = true
                                } label : {
                                    SettingRow(title: "Clear Data", iconName: "chevron.right")
                                        .foregroundColor(.red)
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
            .alert("Clear All Data", isPresented: $showingClearDataAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Yes", role: .destructive) {
                    performClearData()
                }
            } message: {
                Text("Are you sure you want to clear all data? This action cannot be undone.")
            }
        }
    }
    
    func clearData() {
        showingClearDataAlert = true
    }
    
    func performClearData() {
        for user in users {
            modelContext.delete(user)
        }
        for taskItem in taskItems {
            modelContext.delete(taskItem)
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
            Spacer()
            Image(systemName: iconName)
        }
        .padding()
    }
}

#Preview {
    InsightsPage()
}
