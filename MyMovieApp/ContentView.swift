//
//  ContentView.swift
//  MyMovieApp
//
//  Created by ali cihan on 29.11.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MoviesViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.movies) { movie in
                Text(movie.title)
            }
            fetchPopularMovies
            fetchUpcomingMovies
        }
        .padding()
    }
    
    @ViewBuilder
    private var fetchPopularMovies: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            Button {
                Task {
                    await viewModel.fetchPopularMovies()
                }
            } label: {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
        }
    }
    
    @ViewBuilder
    private var fetchUpcomingMovies: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            Button {
                Task {
                    await viewModel.fetchUpcomingMovies()
                }
            } label: {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
        }
    }
}

#Preview {
    ContentView()
}
