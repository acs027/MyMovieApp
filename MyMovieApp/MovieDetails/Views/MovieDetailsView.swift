//
//  MovieDetailsView.swift
//  MyMovieApp
//
//  Created by ali cihan on 25.12.2024.
//

import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel

    
    var body: some View {
        Group {
            if viewModel.isDetailsLoading {
                ProgressView()
                    .onAppear {
                        fetchMovieDetails()
                    }
            } else {
                VStack(alignment: .leading) {
                    backdrop
                    movieTitle
                    HStack {
                        releaseDate
                        Spacer()
                        movieVotes
                    }
                    genres
                    movieBudget
                    movieRevenue
                    movieRuntime
                    overview
                    goToImdb
                }
                .padding()
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: viewModel.backgroundColor.color))
        .animation(.default, value: viewModel.backgroundColor.color)
    }
    
    @ViewBuilder
    var backdrop: some View {
        if let imageData = viewModel.backdropData.first  {
            Image(uiImage: UIImage(data: imageData)!)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        } else {
            ProgressView()
                .onAppear {
                    Task {
                        await viewModel.fetchImageData()
                    }
                }
        }
    }
    
    var movieTitle: some View {
        Text(viewModel.movieDetails?.title ?? "Unknown")
            .font(.largeTitle)
            .bold()
    }
    
    var releaseDate: some View {
        HStack {
            Text("Release date: ")
                .bold()
            Text(viewModel.movieDetails?.releaseDate ?? "Unknown")
        }
    }
    
    var overview: some View {
        Text(viewModel.movieDetails?.overview ?? "Unknown")
    }
    
    var genres: some View {
        HStack {
            Text("Genres: ").bold()
            if let movieDetails = viewModel.movieDetails {
                Text(movieDetails.genres.compactMap { $0.name }.joined(separator: ", ")
                )
            }
        }
    }
    
    var production: some View {
        HStack {
            if viewModel.movieDetails != nil {
                ForEach(viewModel.movieDetails!.productionCompanies, id:\.self.id) { company in
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
            if let imdbId = viewModel.movieDetails?.imdbId {
                ImdbWebView(imdbId: imdbId)
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
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    var movieVotes: some View {
        HStack {
            Image(systemName: "star")
            Text(String(
                format: "%.1f", viewModel.movieDetails?.voteAverage ?? 0.0
            ) + "(\(viewModel.movieDetails?.voteCount ?? 0))")
        }
    }
    
    var movieBudget: some View {
        HStack {
            Text("Budget :")
                .bold()
            Text("\(viewModel.movieDetails?.budget ?? 0)")
        }
    }
    
    var movieRevenue: some View {
        HStack {
            Text("Revenue :")
                .bold()
            Text("\(viewModel.movieDetails?.revenue ?? 0)")
        }
    }
    
    var movieRuntime: some View {
        HStack {
            Text("Runtime :")
                .bold()
            Text("\(viewModel.movieDetails?.runtime ?? 0)")
        }
    }
    
    func fetchMovieDetails() {
        viewModel.fetchMovieDetails()
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    ProgressView()
        .sheet(isPresented: $isPresented) {
            MovieDetailsView(viewModel: MovieDetailsViewModel(id: 945961))
        }
}
