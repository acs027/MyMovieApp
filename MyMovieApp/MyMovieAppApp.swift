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
    @State var selectedTab: CustomTab = .home
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    switch monitor.status {
                    case .connected:
                        if isOnboarding {
                            OnboardingView()
                        } else {
                            mainViews
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
    
    var mainViews: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .home:
                    MoviesView(selectedTab: $selectedTab)
                        .environmentObject(viewModel)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                case .popularMovies:
                    MovieList(for: .popular)
                case .upcomingMovies:
                    MovieList(for: .upcoming)
                case .nowplayingMovies:
                    MovieList(for: .nowPlaying)
                }
            }
            .safeAreaInset(edge: .bottom) {
                CustomTabView(selectedTab: $selectedTab)
            }
//            CustomTabView(selectedTab: $selectedTab)
        }
    }
}
