//
//  Profile.swift
//  Foco
//
//  Created by Christian Gunawan on 01/04/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @State private var isShowingLogoutAlert = false
    
    var body: some View {
        VStack {
            TabView {
                VStack {
                    Text("My Profile").font(.title)
                        .padding(10).bold()

                    Image("poto")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(10)

                    Text("Hai, Arya!")
                        .font(.title)
                        .padding(15).bold()
                    
                    Spacer()
                    
                    List {
                        NavigationLink(destination: Text("Detail 1")) {
                            HStack {
                                Text("What is Foco")
                            }
                        }
                        NavigationLink(destination: Text("Detail 2")) {
                            HStack {
                                Text("FAQ")
                            }
                        }
                        NavigationLink(destination: Text("Detail 3")) {
                            HStack {
                                Text("Give us Feedback")
                            }
                        }
                        NavigationLink(destination: Text("Detail 4")) {
                            HStack {
                                Text("Privacy Policy")
                            }
                        }
                        
                        Button(action: {
                            self.isShowingLogoutAlert = true
                        }) {
                            HStack {
                                Text("Logout").foregroundColor(.red)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 5)
                        }
                        .alert(isPresented: $isShowingLogoutAlert) {
                            Alert(title: Text("Logout"), message: Text("Are you sure you want to logout?"), primaryButton: .default(Text("Yes")) {
                                // Perform logout action here
                            }, secondaryButton: .cancel())
                        }
                    }
                }
                .tabItem {
                    Text("Profile")
                    Image(systemName: "person")
                }
                
                Text("Tab Content 2")
                    .tabItem {
                        Text("Tab 2")
                        Image(systemName: "star")
                    }
                
                Text("Tab Content 3")
                    .tabItem {
                        Text("Tab 3")
                        Image(systemName: "gear")
                    }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
