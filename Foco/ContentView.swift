//
//  ContentView.swift
//  Foco
//
//  Created by Arya Adyatma on 28/03/24.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var tasks: [TaskItem]
    @Query private var users: [ProfileModel]
    
    @State private var selection: Tab = .tasks
    
    enum Tab {
        case tasks
        case focusMode
        case insights
    }
    
    var body: some View {
        if users.isEmpty {
            OnboardingPages()
        } else {
            TabView(selection: $selection) {
                TaskListPage()
                    .tabItem {
                        Label("Tasks", systemImage: "calendar")
                    }
                    .tag(Tab.tasks)
                FocusModePage()
                    .tabItem {
                        Label("Focus Mode", systemImage: "hourglass")
                    }
                    .tag(Tab.focusMode)
                InsightsPage()
                    .tabItem {
                        Label("Insights", systemImage: "person.circle")
                    }
                    .tag(Tab.insights)
            }
            .toolbarBackground(Color.white, for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TaskItem.self, ProfileModel.self], inMemory: true)
}

