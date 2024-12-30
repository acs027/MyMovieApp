//
//  HorizontalMovies.swift
//  MyMovieApp
//
//  Created by ali cihan on 9.12.2024.
//

import SwiftUI

struct HorizontalMovies: View {
    @EnvironmentObject var viewModel: MoviesViewModel
    var movies: [CDMovie]
    var title: String
    var imageWidth = UIScreen.main.bounds.width / 3
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(movies) { movie in
                        moviePoster(of: movie)
                            .onTapGesture {
                                viewModel.showMovieDetails(id: Int(movie.id))
                            }
                    }
                }
            }
        }
    }
    
    var header: some View {
        Text(title)
            .font(.largeTitle)
            .bold()
    }
    
    @ViewBuilder
    func moviePoster(of movie: CDMovie) -> some View {
        if let data = viewModel.posterImages[movie.posterPath!] {
            Image(uiImage: UIImage(data: data)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageWidth)
                .id(movie.id)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            ProgressView()
                .frame(width: imageWidth)
                .onAppear {
                    Task {
                        await viewModel.fetchImage(with: movie.posterPath!)
                    }
                }
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = MoviesViewModel()
    ScrollView{
        VStack {
            HorizontalMovies(movies: viewModel.movies, title: "Popular Movies")
                .environmentObject(viewModel)
        }
    }
    .padding()
    
}
