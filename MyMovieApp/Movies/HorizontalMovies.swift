//
//  HorizontalMovies.swift
//  MyMovieApp
//
//  Created by ali cihan on 9.12.2024.
//

import SwiftUI
import CoreData

struct HorizontalMovies: View {
    @EnvironmentObject var viewModel: MoviesViewModel
    @FetchRequest var movies: FetchedResults<CDMovie>
    var category: MovieCategory
    var title: String
    var imageWidth = UIScreen.main.bounds.width / 3
    
    init(for category: MovieCategory) {
        self.category = category
        self.title = category.description
        let fetchRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        fetchRequest.predicate = category.predicate
        fetchRequest.sortDescriptors = []
        fetchRequest.fetchLimit = 20
        _movies = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            if movies.isEmpty {
                ProgressView()
                    .onAppear {
                        Task {
                            await fetchMovies()
                        }
                    }
            } else {
                horizontalScrollView
            }
        }
    }
    
    var header: some View {
        Text(title)
            .font(.largeTitle)
            .bold()
    }
    
    var horizontalScrollView: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(movies) { movie in
                    moviePoster(of: movie)
                        .onTapGesture {
                            viewModel.showMovieDetails(of: movie)
                        }
                }
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 1)
                    .overlay {
                        Text("Load More")
                    }
                    .frame(width: imageWidth)
            }
        }
    }
    
//    @ViewBuilder
//    func moviePoster(of movie: CDMovie) -> some View {
//        if let imageData =  viewModel.moviePosterData[Int(movie.id)] {
//            Image(uiImage: UIImage(data: imageData)!)
//        } else {
//            ProgressView()
//                .onAppear {
//                    Task {
//                        await viewModel.fetchImageData(for: movie)
//                    }
//                }
//        }
//    }
    
    @ViewBuilder
    func moviePoster(of movie: CDMovie) -> some View {
        AsyncImage(url: viewModel.posterUrl(for: movie)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            case .failure(_):
                Text("Failed to load image")
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
        }
    }
    
    func fetchMovies() async {
        switch category {
        case .nowPlaying:
            await viewModel.fetchNowPlayingMovies()
        case .popular:
            await viewModel.fetchPopularMovies()
        case .upcoming:
            await viewModel.fetchUpcomingMovies()
        }
    }
}

enum MovieCategory: CustomStringConvertible {
    
    case popular
    case upcoming
    case nowPlaying
    
    var description: String {
        switch self {
            case .popular: return "Popular Movies"
            case .upcoming: return "Upcoming Movies"
            case .nowPlaying: return "Now Playing Movies"
        }
    }
    
    var predicate: NSPredicate {
           switch self {
           case .popular:
               return NSPredicate(format: "isPopular == %@", NSNumber(value: true))
           case .upcoming:
               return NSPredicate(format: "isUpcoming == %@", NSNumber(value: true))
           case .nowPlaying:
               return NSPredicate(format: "isNowPlaying == %@", NSNumber(value: true))
           }
       }
}

#Preview {
    @Previewable @StateObject var viewModel = MoviesViewModel()
    ScrollView{
        VStack {
            HorizontalMovies(for: .popular)
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
    .padding()
}
