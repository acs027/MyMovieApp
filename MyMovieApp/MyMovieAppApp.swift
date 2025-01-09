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
    @StateObject var viewModel = MoviesViewModel()
    @State var launchScreenPresented = false
    @StateObject var monitor = Monitor()
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    switch monitor.status {
                    case .connected:
                        if isOnboarding {
                            OnboardingView()
                        } else {
                            MoviesView()
                                .environmentObject(viewModel)
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        }
                    default:
                        Text("You are not connected to the internet.")
                    }
                    LaunchScreenAnimation(isPresented: $launchScreenPresented)
                        .opacity(launchScreenPresented ? 0 : 1)
                }
            }
        }
    }
}
