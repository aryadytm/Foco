//
//  FocusModePage.swift
//  Foco
//
//  Created by Arya Adyatma on 01/04/24.
//

import SwiftUI

struct FocusModePage: View {
    
    private var currentDate: String {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, d MMMM YYYY"
            let formattedDate = dateFormatter.string(from: currentDate)
            return formattedDate
    }
    
    private var task: TaskItem = TaskItem(startDate: Date(), endDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!, title: "Math: Linear Algebra", desc: "Chapter 5: Vector Spaces", isDone: false)
    
    init() {
//        // Customize the navigation bar appearance
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(Color.blue) // Replace with the exact color
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        
//        // Apply the appearance to all navigation bars
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Incoming")
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
                    
                    Text(task.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                    
                    Text(task.getClockStr())
                    
                    // Image placeholder
                    Image("FocoFocus1") // Replace with the actual image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                        .background(Circle().fill(Color.focoPrimary.opacity(0.3)).frame(width: 180, height: 180))
                        .padding(.top, 10)
                    
                    Text("01:30")
                        .font(.system(size: 80))
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .opacity(0.7)
                    
                    Button(action: {
                        // Handle button tap
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                            Text("Start Now!")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.focoPrimary) // Replace with the button's background color
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .background(Color.focoBackground)
        }
    }

}

#Preview {
    FocusModePage()
}
