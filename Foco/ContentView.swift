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
    
    @State private var selection: Tab = .tasks
    
    enum Tab {
        case tasks
        case focusMode
        case insights
    }
    
    var body: some View {
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

#Preview {
    ContentView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}






// BELOW IS JUST EXAMPLE!






struct ExampleContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
