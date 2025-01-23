//
//  MoviePoster.swift
//  MyMovieApp
//
//  Created by ali cihan on 23.01.2025.
//

import SwiftUI

struct MoviePoster: View {
    let movieTitle: String?
    let posterURL: URL?
    let cornerRadius: CGFloat
    let posterWidth: CGFloat
    let posterHeight: CGFloat
    
    var body: some View {
        AsyncImage(url: posterURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    
            default:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .overlay {
                        Text(movieTitle ?? "")
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                            .foregroundStyle(.white)
                    }
            }
        }
        .frame(width: posterWidth, height:
                posterHeight)
    }
}

#Preview {
    let url = "https://image.tmdb.org/t/p/w92/bx92hl70NUhojjO3eV6LqKllj4L.jpg"
    let width = UIScreen.main.bounds.width / 3
    MoviePoster(movieTitle: "Title", posterURL: URL(string: url), cornerRadius: 15, posterWidth: width, posterHeight: width * 1.5)
}
