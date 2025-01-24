//
//  HorizontalMovies.swift
//  MyMovieApp
//
//  Created by ali cihan on 9.12.2024.
//

import SwiftUI
import CoreData

struct HorizontalMovies: View {
    @EnvironmentObject var viewModel: CatalogueViewModel
    @FetchRequest var movies: FetchedResults<CDMovie>
    @Binding var selectedTab: CustomTab
    var category: MovieCategory
    var title: String
    
    init(for category: MovieCategory, selectedTab: Binding<CustomTab>) {
        self.category = category
        self.title = category.description
        let fetchRequest = PersistenceController.shared.fetchRequest(for: category)
        _movies = FetchRequest(fetchRequest: fetchRequest)
        _selectedTab = selectedTab
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            if movies.isEmpty {
                ProgressView()
                    .onAppear {
                        viewModel.fetchFromAPI(for: category)
                    }
            } else {
                posters
            }
        }
    }
    
    var header: some View {
        Text(title)
            .font(.largeTitle)
            .bold()
    }
    
    var posters: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(movies) { movie in
                    moviePoster(of: movie)
                        .onTapGesture {
                            viewModel.showMovieDetails(of: movie)
                        }
                }
                RoundedRectangle(cornerRadius: Constants.Poster.cornerRadius)
                    .fill(.secondary)
                    .overlay {
                        Text("Discover more")
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                    }
                    .frame(width: Constants.Poster.width, height: Constants.Poster.height)
                    .onTapGesture {
                        selectedTab = category.tab
                    }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    func moviePoster(of movie: CDMovie) -> some View {
        MoviePoster(movieTitle: movie.title, posterURL: viewModel.posterUrl(for: movie), cornerRadius: Constants.Poster.cornerRadius, posterWidth: Constants.Poster.width, posterHeight: Constants.Poster.height)
    }
    
    private struct Constants {
        struct Poster {
            static let width = UIScreen.main.bounds.width / 3
            static let aspectRatio = 1.5
            static let height = width * aspectRatio
            static let cornerRadius: CGFloat = 15
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = CatalogueViewModel()
    @Previewable @State var selectedTab = CustomTab.catalogue
    ScrollView{
        VStack {
            HorizontalMovies(for: .popular, selectedTab: $selectedTab)
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
    .padding()
}
