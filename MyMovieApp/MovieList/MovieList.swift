//
//  VerticalMoviesList.swift
//  MyMovieApp
//
//  Created by ali cihan on 14.01.2025.
//

import SwiftUI

struct MovieList: View {
    @ObservedObject var viewModel: MovieListViewModel
//    @State var isDetailsShowing = false
    var category: MovieCategory
    var title: String
    var imageWidth = UIScreen.main.bounds.width / 4
    
    init(for category: MovieCategory) {
        self.viewModel = MovieListViewModel(for: category)
        self.category = category
        self.title = category.description
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.movies.isEmpty {
                ProgressView()
            } else {
                movies
            }
        }
        .padding(.horizontal)
        .navigationTitle(category.description)
    }
    
    var movies: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(viewModel.movies) { movie in
                    HStack {
                        movieInfo(for: movie)
                        Spacer()
                        moviePoster(of: movie)
                    }
                    .onTapGesture {
                        print(movie.id)
                        viewModel.showDetails(with: Int(movie.id))
                    }
                    .sheet(isPresented: $viewModel.isDetailsShowing, content: {
                        let movieDetailsViewModel = MovieDetailsViewModel(id: viewModel.tappedMovieId)
                        NavigationStack {
                            MovieDetailsView(viewModel: movieDetailsViewModel)
                        }
                    })
                }
                loadMore
            }
        }
        .scrollIndicators(.hidden)
    }
    
    var loadMore: some View {
        RoundedRectangle(cornerRadius: 25)
            .overlay {
                Text("Load More")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.background)
            }
            .frame(height: 50)
            .onTapGesture {
                viewModel.fetchMovies()
            }
    }
    
    func movieInfo(for movie: CDMovie) -> some View {
        VStack(alignment: .leading) {
            Text(movie.title ?? "Unknown")
                .font(.title3)
                .bold()
                .lineLimit(2)
                .minimumScaleFactor(0.4)
            HStack {
                Image(systemName: "star")
                Text(String(
                    format: "%.1f", movie.voteAverage
                ) + "(\(movie.voteCount))")
            }
            HStack {
                Text("Release date: ")
                    .bold()
                Text(movie.releaseDate ?? "Unknown")
            }
            genreText(movie: movie)
        }
    }
    
    func genreText(movie: CDMovie) -> some View {
        Text(viewModel.getGenresAsString(for: movie))
            .lineLimit(2)
            .minimumScaleFactor(0.7)
    }
    
    func moviePoster(of movie: CDMovie) -> some View {
        MoviePoster(movieTitle: movie.title, posterURL: viewModel.posterUrl(for: movie), cornerRadius: Constants.Poster.cornerRadius, posterWidth: Constants.Poster.width, posterHeight: Constants.Poster.height)
    }
    
    private struct Constants {
        struct Poster {
            static let width = UIScreen.main.bounds.width / 4
            static let aspectRatio = 1.5
            static let height = width * aspectRatio
            static let cornerRadius: CGFloat = 15
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView{
            VStack {
                MovieList(for: .upcoming)
            }
        }
        .padding()
    }
}
