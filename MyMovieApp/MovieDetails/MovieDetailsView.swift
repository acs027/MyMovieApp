//
//  MovieDetailsView.swift
//  MyMovieApp
//
//  Created by ali cihan on 25.12.2024.
//

import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var viewmodel: MovieDetailsViewModel
    
    var body: some View {
        if viewmodel.isDetailsLoading {
            ProgressView()
                .onAppear {
                    fetchMovieDetails()
                }
        } else {
            VStack(alignment: .leading) {
                backdrop
                movieTitle
                releaseDate
                overview
                goToImdb
                movieVotes
            }
            .padding()
        }
    }
    
    var backdrop: some View {
        AsyncImage(url: viewmodel.getBackdropURL()) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            case .failure(_):
                Text("Failed to load image")
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
        }
    }
    
    var movieTitle: some View {
        Text(viewmodel.movieDetails?.originalTitle ?? "Unknown")
            .font(.largeTitle)
            .bold()
    }
    
    var releaseDate: some View {
        HStack {
            Text("Release date: ")
                .bold()
            Text(viewmodel.movieDetails?.releaseDate ?? "Unknown")
        }
    }
    
    var overview: some View {
        Text(viewmodel.movieDetails?.overview ?? "")
    }
    
    var genres: some View {
        HStack {
            Text("Genres: ")
            if viewmodel.movieDetails != nil {
                ForEach(viewmodel.movieDetails!.genres, id:\.self.id) { genre in
                    Text(genre.name ?? "unknown")
                }
            }
        }
        .padding()
    }
    
    var production: some View {
        HStack {
            if viewmodel.movieDetails != nil {
                ForEach(viewmodel.movieDetails!.productionCompanies, id:\.self.id) { company in
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray)
                        .frame(height: 50)
                        .overlay {
                            Text(company.name ?? "Unknown")
                        }
                }
            }
        }
    }
    
    var goToImdb: some View {
        NavigationLink {
            if let imdbId = viewmodel.movieDetails?.imdbId {
                MovieDetailsImdb(imdbId: imdbId)
            } else {
                Text("Couldn't reach to the IMDB page.")
            }
        } label: {
            RoundedRectangle(cornerRadius: 25)
                .frame(height: 50)
                .overlay {
                    HStack {
                        Text("Imdb")
                        Image(systemName: "arrowshape.right")
                    }
                    .foregroundStyle(.black)
                }
        }
    }
    
    var movieVotes: some View {
        HStack {
            Image(systemName: "star")
            Text(String(
                format: "%.1f", viewmodel.movieDetails?.voteAverage ?? 0.0
            ) + "(\(viewmodel.movieDetails?.voteCount ?? 0))")
        }
    }
    
    
    func fetchMovieDetails() {
        Task {
            await viewmodel.fetchMovieDetails()
        }
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    ProgressView()
        .sheet(isPresented: $isPresented) {
            MovieDetailsView(viewmodel: MovieDetailsViewModel(id: 945961))
        }
}
