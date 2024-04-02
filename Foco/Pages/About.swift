//
//  About.swift
//  Foco
//
//  Created by Christian Gunawan on 02/04/24.
//

import SwiftUI

struct About: View {
    let appVersion: String = {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            fatalError("Version information not found")
        }
        return version
    }()
    
    let buildNumber: String = {
        guard let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            fatalError("Build information not found")
        }
        return build
    }()
    
    var body: some View {
        GeometryReader { geometry in
            Color(red: 242/255, green: 242/255, blue: 247/255)
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                VStack(spacing: 0) {
                    VStack {
                        Text("About")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        Image("Group 67")
                    }
                    
                    VStack {
                        List {
                            HStack {
                                Text("Version")
                                Spacer()
                                Text("\(appVersion)")
                            }
                            
                            HStack {
                                Text("Build")
                                Spacer()
                                Text("\(buildNumber)")
                            }
                        }
                        .frame(height: 150.0)
                        
                        List {
                            NavigationLink(destination:EmptyView()){
                                Text("Write A Review")
                            }.foregroundColor(.black)
                            
                            NavigationLink(destination:EmptyView()){
                                Text("Share PoCo To Friends").foregroundColor(.black)
                            }
                            NavigationLink(destination:EmptyView()){
                                Text("Support").foregroundColor(.black)
                            }
                            NavigationLink(destination:EmptyView()){
                                Text("Send Feedback").foregroundColor(.black)
                            }
                        
                            NavigationLink(destination:EmptyView()){
                                Text("What is PoCo").foregroundColor(.black)
            
                            }
                           
                        }
                        .padding(.top, 0.0)
                        .frame(height: 300.0)
                    }
                }
            }
        }
    }
}


#Preview {
    About()
}
