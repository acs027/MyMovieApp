//
//  OnboardingViewModel.swift
//  MyMovieApp
//
//  Created by ali cihan on 2.12.2024.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    
    init() {
        
    }
    
    func info(index: Int) -> String {
        OnboardingInfo().info[index]
    }
    
    func imageName(index: Int) -> String {
        OnboardingInfo().imagesName[index]
    }
}
