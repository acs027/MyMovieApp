//
//  VerticalMoviesList.swift
//  MyMovieApp
//
//  Created by ali cihan on 14.01.2025.
//

import SwiftUI

struct MovieList: View {
    @ObservedObject var viewModel: MovieListViewModel
    @State var isDetailsShowing = false
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
            LazyVStack {
                ForEach(viewModel.movies) { movie in
                    HStack {
                        movieInfo(for: movie)
                        Spacer()
                        moviePoster(of: movie)
                    }
                    .onTapGesture {
                        isDetailsShowing.toggle()
                    }
                    .sheet(isPresented: $isDetailsShowing, content: {
                        let movieDetailsViewModel = MovieDetailsViewModel(id: Int(movie.id))
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
                viewModel.checkAndFetch()
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
    
    
    @ViewBuilder
    func moviePoster(of movie: CDMovie) -> some View {
        AsyncImage(url: viewModel.posterUrl(for: movie)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            default:
                RoundedRectangle(cornerRadius: 15)
                    .overlay {
                        Text(movie.title ?? "")
                            .foregroundStyle(.white)
                    }
            }
        }
        .frame(width: imageWidth, height: imageWidth * 1.5)
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
