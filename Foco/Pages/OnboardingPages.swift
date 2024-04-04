
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
    
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @State private var shouldNavigate = false
    @State private var selection: String? = nil
    
    @Query var users: [ProfileModel]
    
    private let pages: [PageModel] = PageModel.samplePages
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                VStack {
                    TabView(selection: $pageIndex) {
                        ForEach(pages.indices, id: \.self) { index in
                            onboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut, value: pageIndex)
                    
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(gradient: Gradient(colors: [Color(red: 0.949, green: 0.949, blue: 0.971), .white]), startPoint: .top, endPoint: .bottom)
    }
    
    @ViewBuilder
    private func onboardingPageView(page: PageModel) -> some View {
        VStack(spacing: 10) {
            Spacer()
            if page != pages.last {
                Image(page.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .padding()
                    .padding(.top)
                Spacer()
            } else {
//                Image(page.image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 300, height: 300)
//                    .padding()
//                    .padding(.top)
            }

            
            VStack {
                if page != pages.last {
                    pageIndicator
                        .padding()
                    
                    Text(page.name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text(page.desc)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(height: 70)
                } else {
                    Spacer()
                }
                

                if page == pages.last {
                    VStack {
//                        NavigationLink(destination: ContentView(), tag: "B", selection: $selection) { EmptyView() }
                        Text(page.name)
                            .font(.title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Text(page.desc)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding()
//                            .frame(height: 70)
                        Text("What should we call you?")
                            .font(.subheadline)
                            .foregroundColor(.focoPrimary)
                        TextField("Your Name", text: $inputValue)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .ignoresSafeArea(.keyboard, edges: .bottom)

                        Button {
                            withAnimation {
                                if inputValue.isEmpty {
                                    return
                                }
                                let newUser = ProfileModel(name: inputValue)
                                modelContext.insert(newUser)
                                //                            selection = "B"
                            }
                            
                        } label: {
                            Text("Let's Go!")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(FilledButtonStyle())
                        .padding(.vertical)
                        
                        Text("")
                            .padding()             
                        Text("")
                            .padding()
                    }
                    .ignoresSafeArea(.keyboard)
                    .padding()
                    Spacer()
                } else {
                    Button(action: incrementPage) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(FilledButtonStyle())
                    .padding()
                }
            }
            .ignoresSafeArea(.keyboard)
            .cornerRadius(20)
            .background(page != pages.last ? .white : .white.opacity(0))
        }
        .background(.focoBackground)
        .ignoresSafeArea(.keyboard)
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(pages.indices, id: \.self) { index in
                Circle()
                    .fill(index == pageIndex ? Color.focoPrimary : Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.top, 10)
    }
    
    func incrementPage() {
        withAnimation {
            pageIndex = pageIndex < pages.count - 1 ? pageIndex + 1 : 0
        }
    }
}

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.focoPrimary)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
#Preview {
    OnboardingPages()
}
