//
//  MyMovieAppApp.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import SwiftUI

@main
struct MyMovieAppApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @State var viewModel = MoviesViewModel()
    @State var launchScreenPresented = false
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    if isOnboarding {
                        OnboardingView()
                    } else {
                        MoviesView()
                            .environmentObject(viewModel)
                    }
                    LaunchScreenAnimation(isPresented: $launchScreenPresented)
                        .opacity(launchScreenPresented ? 0 : 1)
                }
            }
          
            
        }
    }
}
