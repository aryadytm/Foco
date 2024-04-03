//
//  ProfilePage.swift
//  Foco
//
//  Created by Arya Adyatma on 01/04/24.
//

import SwiftUI

struct ProfilePage: View {
    @State private var keepScreenOn = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            Text("My Profile")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom)
                        }
                        Spacer()
                    }
                    .background(Color.focoPrimary)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Profile Image and Greeting
                            HStack(alignment: .top) {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .padding(.top, 8)
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                
                                VStack(alignment: .leading) {
                                    Text("Hi, Arya!")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("You have completed 370 tasks since using this app")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.leading, 8)
                                .padding(.top, 8)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            // Task and Distraction Stats
                            HStack(spacing: 20) {
                                StatisticView(title: "Tasks completed\nthis week", value: "20")
                                    .background(Color.white)
                                    .cornerRadius(10)
                                StatisticView(title: "Distraction time\nthis week", value: "1h 28m")
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }
                   
                            
                            // Settings
                            VStack(spacing: 10) {
                                NavigationLink(destination: Text("Whitelist Apps")) {
                                    SettingRow(title: "Whitelist Apps", iconName: "chevron.right")
                                }
                                
                                Toggle(isOn: $keepScreenOn) {
                                    Text("Keep Screen On")
                                }
                                .padding()
                                
                                NavigationLink(destination: Text("FAQ")) {
                                    SettingRow(title: "FAQ", iconName: "chevron.right")
                                }
                                
                                NavigationLink(destination: Text("Privacy Policy")) {
                                    SettingRow(title: "Privacy Policy", iconName: "chevron.right")
                                }
                                
                                Button(action: {
                                    // Handle logout action
                                }) {
                                    Text("Logout")
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding()
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
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
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
    ProfilePage()
}
