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
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
            } else {
                ContentView()
            }
        }
    }
}
