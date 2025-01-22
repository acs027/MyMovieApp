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
    var imageWidth = UIScreen.main.bounds.width / 3
    
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
                RoundedRectangle(cornerRadius: 15)
                    .overlay {
                        Text("Load More")
                            .foregroundStyle(.white)
                    }
                    .frame(width: imageWidth, height: imageWidth * 1.5)
                    .onTapGesture {
                        selectedTab = category.tab
                    }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    func moviePoster(of movie: CDMovie) -> some View {
        AsyncImage(url: viewModel.posterUrl(for: movie)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .frame(width: imageWidth, height: imageWidth * 1.5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            default:
                RoundedRectangle(cornerRadius: 15)
                    .overlay {
                        Text(movie.title ?? "")
                            .foregroundStyle(.white)
                    }
                    .frame(width: imageWidth, height: imageWidth * 1.5)
            }
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
