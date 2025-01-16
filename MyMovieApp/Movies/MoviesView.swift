//
//  ContentView.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import SwiftUI

struct MoviesView: View {
    @EnvironmentObject var viewModel: MoviesViewModel
    @Binding var selectedTab: CustomTab
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                HorizontalMovies(for: .upcoming, selectedTab: $selectedTab)
                HorizontalMovies(for: .nowPlaying, selectedTab: $selectedTab)
                HorizontalMovies(for: .popular, selectedTab: $selectedTab)
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .sheet(isPresented: $viewModel.isDetailsShowing, content: {
            let movieDetailsViewModel = MovieDetailsViewModel(id: viewModel.tappedMovieId)
            NavigationStack {
                MovieDetailsView(viewModel: movieDetailsViewModel)
            }
        })
    }
}

#Preview {
    @Previewable @StateObject var viewModel = MoviesViewModel()
    @Previewable @State var selectedTab = CustomTab.home
    MoviesView(selectedTab: $selectedTab)
        .environmentObject(viewModel)
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
