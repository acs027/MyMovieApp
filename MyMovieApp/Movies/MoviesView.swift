//
//  ContentView.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import SwiftUI

struct MoviesView: View {
    @EnvironmentObject var viewModel: MoviesViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading){
                HorizontalMovies(movies: viewModel.movies.filter({ $0.isUpcoming }),title: "Upcoming Movies")
                HorizontalMovies(movies: viewModel.movies.filter({ $0.isNowPlaying }),title: "Now Playing")
                HorizontalMovies(movies: viewModel.movies.filter({ $0.isPopular }),title: "Popular Movies")
            }
            .scrollIndicators(.hidden)
        }
        .padding()
        .sheet(isPresented: $viewModel.isDetailsShowing, content: {
            let movieDetailsViewModel = MovieDetailsViewModel(id: viewModel.tappedMovieId)
            NavigationStack {
                MovieDetailsView(viewmodel: movieDetailsViewModel)
            }
        })
    }
}

#Preview {
    @Previewable @StateObject var viewModel = MoviesViewModel()
    MoviesView()
        .environmentObject(viewModel)
}
