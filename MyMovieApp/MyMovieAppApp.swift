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
    @StateObject var viewModel = CatalogueViewModel()
    @State var launchScreenPresented = false
    @StateObject var monitor = Monitor()
    let persistenceController = PersistenceController.shared
    @State var selectedTab: CustomTab = .catalogue
    
    init() {
        persistenceController.cleanOldData()
        ImageConfigurationManager.shared.fetchConfiguration()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    switch monitor.status {
                    case .connected:
                        if isOnboarding &&  launchScreenPresented {
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
            switch selectedTab {
            case .catalogue:
                CatalogueView(selectedTab: $selectedTab)
                    .environmentObject(viewModel)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .transition(.opacity)
            case .upcomingMovies:
                MovieList(for: .upcoming)
                    .transition(.opacity)
                    
            case .nowplayingMovies:
                MovieList(for: .nowPlaying)
                    .transition(.opacity)
                    
            case .popularMovies:
                MovieList(for: .popular)
                    .transition(.opacity)
            }
        }
        .animation(.default, value: selectedTab)
        .safeAreaInset(edge: .bottom) {
            CustomTabView(selectedTab: $selectedTab)
        }
    }
}
