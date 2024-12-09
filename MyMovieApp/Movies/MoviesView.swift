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
//                popularMovies
                HorizontalMovies(title: "Now Playing")
//                    .environmentObject(viewModel)
                HorizontalMovies(title: "Popular Movies")
//                    .environmentObject(viewModel)
            }
            .scrollIndicators(.hidden)
        }
        //            fetchPopularMovies
        //            fetchUpcomingMovies
        
        .padding()
    }
}

#Preview {
    @Previewable @StateObject var viewModel = MoviesViewModel()
    MoviesView()
        .environmentObject(viewModel)
        .onAppear {
            viewModel.imageConfiguration = MockDataProvider().imageConfiguration()
            viewModel.movies = MockDataProvider().popularMovies()
        }
}
