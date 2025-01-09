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
                HorizontalMovies(for: .upcoming)
                HorizontalMovies(for: .nowPlaying)
                HorizontalMovies(for: .popular)
            }
        }
        .scrollIndicators(.hidden)
        .padding()
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
    MoviesView()
        .environmentObject(viewModel)
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
