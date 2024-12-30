//
//  MovieDetailsImdb.swift
//  MyMovieApp
//
//  Created by ali cihan on 30.12.2024.
//

import SwiftUI

struct MovieDetailsImdb: View {
    let webView = WebView()
    @State var urlString: String
    
    init(imdbId: String) {
        let baseUrl = "https://www.imdb.com/title/"
        self.urlString = baseUrl + imdbId
    }
    
    var body: some View {
        webView
            .onAppear {
                webView.loadURL(urlString: urlString)
            }
            .ignoresSafeArea()
    }
}

#Preview {
    MovieDetailsImdb(imdbId: "tt18412256")
}
