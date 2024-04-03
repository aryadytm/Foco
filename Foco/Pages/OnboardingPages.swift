//
//  OnboardingPages.swift
//  Foco
//
//  Created by Ahmad Syafiq Kamil on 02/04/24.
//

import SwiftUI
import SwiftData

struct OnboardingPages: View {
    @State private var pageIndex = 0
    @State private var inputValue: String = ""
    @Environment(\.modelContext) private var modelContext
    @Query private var profile: [ProfileModel]
    @State private var shouldNavigate = false
    
    private let pages : [PageModel] = PageModel.samplePages
    private let dotAppearance = UIPageControl.appearance()
    
    var body: some View {
        NavigationView {
            TabView(selection: $pageIndex){
                ForEach(pages) { page in
                    VStack{
                        VStack(spacing: 20, content: {
                            ZStack(content: {
                                Circle()
                                    .fill(Color(red: 0.911, green: 0.946, blue: 0.517))
                                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                    .frame(width: 250, height: 250)
                                Image("\(page.image)")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .frame(width: 400,height: 400)
                            })
                            Spacer()
                            ZStack(content: {
                                Rectangle()
                                    .fill(Color.white)
                                    .background(.gray.opacity(0.10))
                                    .cornerRadius(50)
                                    .shadow(color: .gray, radius: 1, x: 0, y: 2)
                                    .clipped()
                                
                                VStack{
                                    Text(page.name)
                                        .font(.title)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(page.desc)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 300)
                                    
                                    if page == pages.last{
                                        
                                        VStack{
                                            TextField("Name", text: $inputValue)
                                                .padding()
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                            
                                            NavigationLink {
                                                TaskListPage()
                                            }label: {
                                                Text("Sign up")
//                                                    .background()
//                                                    .onTapGesture {
//                                                        <#code#>
//                                                    }
                                                
//                                                Button("Sign up", action: {
//                                                    saveName()
//                                                })
//                                                .buttonStyle(.borderedProminent)
                                            }
                                            
                                        }
                                        //                                        NavigationLink(detination: TaskListPage(){
                                        //                                    }
                                    }else {
                                        Button("next", action: increamentPage)
                                            .buttonStyle(BorderlessButtonStyle())
                                            .frame(width: 300)
                                            .padding()
                                            .background(Color(red: 0.233, green: 0.304, blue: 0.517))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        
                                    }
                                }
                            })
                        })
                    }
                    .tag(page.tag)
                }
            }
            
            .background(Color(red: 0.949, green: 0.949, blue: 0.971))
            .animation(.easeInOut,value: pageIndex)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .onAppear{
                dotAppearance.currentPageIndicatorTintColor = .black
                dotAppearance.pageIndicatorTintColor = .gray
        }
        }
    }
    
    func increamentPage( ){
        pageIndex += 1
    }
    
    func goToZero( ){
        pageIndex = 0
    }
    
    func saveName(){
//        let newName = ProfileModel(name: inputValue )
//        modelContext.insert(newName)
        
        
    }
}

#Preview {
    OnboardingPages()
}
