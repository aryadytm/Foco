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
    var nama:String
    var task:Int
    var taskCompleted:Int
    var taskTotal:Int
    @State private var toggle1 = false
    @State private var isPresented = false
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Image("RectangleInsightBG")
                    Text("Insight")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                }
                
                ZStack{
                    Image("Rectangle84")
                    HStack {
                        VStack(alignment: .leading){
                            Text("Hai " + nama + "!")
                                .font(.title2)
                            Text("You have completed \(task) tasks")
                            Text("since using this app!")
                            
                        }
                        .padding(10.0)
                    }
                }
                Spacer()
                
            
                    HStack {
                        VStack{
                            ZStack{
                                HStack {
                                    Image("Rectangle 81")
                                    Spacer()
                                    
                                }
                                .padding(.leading, 50.0)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Task Completed")
                                        Text("This Week")
                                        Text("\(taskCompleted)" + "/" + "\(taskTotal)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .padding(.top, 1.0)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.leading, 60)
                                
                            }
                            
                            Spacer()
                        }
                        
                        
                        VStack{
                            ZStack{
                                HStack {
                                    Image("Rectangle 81")
                                    Spacer()
                                    
                                }
                                .padding(.trailing, 40)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Task Completed")
                                        Text("This Week")
                                        Text("1h 22m")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .padding(.top, 1.0)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20.0)
                                
                            }
                            
                            Spacer()
                        }
                        
                    }
                
                
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .padding()

                        VStack {
                            HStack {
                                
                                HStack{
                                    Button("Whitelist App")
                                    {
                                       self.isPresented = true
                                    }
                                    .padding(.horizontal, 10.0)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            
                            
                            .padding(.horizontal, 30.0)

                            HStack {
                                Toggle("Keep Screen On", isOn: $toggle1)
                            }
                            .padding(.horizontal, 40.0)
                            
                        }
                       
                    }
                Spacer()
                    .sheet(isPresented: $isPresented) {
                        SheetView(isPresented: $isPresented)
                }
                    VStack {
                        NavigationLink(destination: EmptyView()) {
                            Text("About")
                                .padding()
                        }
                        Spacer()
                    }
                
            
                
                Image("Group 66")
       
                
                
                
                
            }
            
            
            
            
            
            
            .background(Color(red: 242/255, green: 242/255, blue: 247/255).edgesIgnoringSafeArea(.all))
        }
    }
}






struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(nama: "Arya", task: 377, taskCompleted: 22,taskTotal: 100)
    }
}


struct SheetView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("Sheet Content")
            Button("Dismiss") {
                self.isPresented = false
            }
        }
        .padding()
    }
}
