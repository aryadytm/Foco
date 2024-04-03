//
//  About.swift
//  Foco
//
//  Created by Christian Gunawan on 02/04/24.
//
import SwiftUI

struct AboutPage: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    }
    
    private let menuItems = [
        ("Write a Review", "Coming soon!"),
        ("Share Foco To Friends", "Coming soon!"),
        ("Support", "Coming soon!"),
        ("Send Feedback", "Coming soon!"),
        ("What is Foco?", "Coming soon!")
    ]
    
    var body: some View {
        GeometryReader { _ in
            Color.gray.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    Text("About")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Image("Group 67")
                }
                .padding()
                
                List {
                    Section {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text(appVersion)
                        }
                        
                        HStack {
                            Text("Build")
                            Spacer()
                            Text(buildNumber)
                        }                        }
                    
                    Section {
                        ForEach(menuItems, id: \.0) { item in
                            NavigationLink(destination: Text(item.1)) {
                                Text(item.0)
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    AboutPage()
}
