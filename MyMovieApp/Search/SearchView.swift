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
    @State var queryString = ""
    
    var fieldWitdh = UIScreen.main.bounds.width / 2
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.movies) { movie in
                    Text("\(movie.title) (\(movie.releaseDate.dateAsYear))")
                }
            }
            .searchable(text: $queryString)
            .onSubmit(of: .search) {
                print("arıyor")
                Task {
                    await viewModel.fetchMovies(query: queryString)
            }
            }
            .onChange(of: queryString) {
                print(queryString)
            }
        }
        
    }
}

#Preview {
    SearchView()
}

