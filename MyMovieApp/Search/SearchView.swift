//
//  SearchView.swift
//  MyMovieApp
//
//  Created by ali cihan on 9.01.2025.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State private var isSearching: Bool = false
//    @State var queryString = ""
    @State var isPresented = true
    @State var isAlertPresented: Bool = false
    
    var animation: Namespace.ID
    
    var fieldWitdh = UIScreen.main.bounds.width / 2
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.movies) { movie in
                    NavigationLink {
                        MovieDetailsView(viewModel: MovieDetailsViewModel(id: movie.id))
                    } label: {
                        Text("\(movie.title) (\(movie.releaseDate.dateAsYear))")
                    }
                }
            }
            .searchable(text: $viewModel.queryString, isPresented: $isPresented)
            .onSubmit(of: .search) {
                searchMovies()
            }
        }
        .navigationTransition(.zoom(sourceID: "zoom", in: animation))
        .alert(viewModel.errorMessage, isPresented: $isAlertPresented) {
            Button("OK", role: .cancel) { clearInput() }
        }
    }
    
    func searchMovies() {
        if viewModel.checkQueryString() {
            Task {
                await viewModel.fetchMovies()
            }
        } else {
            isAlertPresented = true
        }
    }
    
    func clearInput() {
        viewModel.queryString = ""
    }
}


#Preview("SearchView Preview") {
    PreviewView()
}

struct PreviewView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @Namespace var animation
    
    init() {
        viewModel.movies = MockDataProvider().popularMovies()
    }
    
    var body: some View {
        SearchView(viewModel: viewModel, animation: animation)
    }
}

