//
//  PageModel.swift
//  Foco
//
//  Created by Ahmad Syafiq Kamil on 02/04/24.
//

import Foundation


struct PageModel: Identifiable, Equatable{
    let id = UUID()
    var name: String
    var desc: String
    var image: String
    var tag: Int
    var red: Double
    var green: Double
    var blue: Double
    
//    init(id: UUID = UUID(), name: String, desc: String, image: String, tag: Int) {
//        self.id = id
//        self.name = name
//        self.desc = desc
//        self.image = image
//        self.tag = tag
//    }
    
    static var samplePage = PageModel(name: "sample1", desc: "sample", image: "onboardingfoco1", tag: 0,red: 0.911, green: 0.946, blue: 0.517)
    static var samplePages: [PageModel] = [
    PageModel(name: "Welcome to Foco!", desc: "The app that tracks your distractions while doing your tasks!", image: "onboardingfoco1", tag: 0, red: 0.911, green: 0.946, blue: 0.517),
    PageModel(name: "Track your Time", desc: "With the help of Dynamic Island, you will be mindful of your time being distracted.", image: "onboardingfoco2", tag: 1,red: 0.911, green: 0.946, blue: 0.517),
    PageModel(name: "Reach your Goals!", desc: "By being mindful of your time, you can reach your goals better!", image: "onboardingfoco3", tag: 2,red: 0.911, green: 0.946, blue: 0.517),
    ]
}
