//
//  TabView.swift
//  MyMovieApp
//
//  Created by ali cihan on 13.01.2025.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: CustomTab
    @State var backgroundColor = Color.white
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Color.white
                    .frame(height: 5)
                HStack(spacing: 50) {
                    popularMovies
                    upcomingMovies
                    Spacer()
                    nowPlayingMovies
                    extraMovies
                }
                .padding()
                .frame(height: 70)
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.5))
            }
            search
        }
    }
    
    var search: some View {
        ZStack {
            Circle()
                .foregroundStyle(backgroundColor)
                .frame(height: 90)
            Circle()
                .overlay {
                    Image(systemName: "magnifyingglass")
                }
                .foregroundStyle(.black)
                .frame(height: 80)
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white)
                .font(.largeTitle)
                .bold()
        }
        .offset(y:-25)
    }
    
    var popularMovies: some View {
        Button {
            withAnimation {
                selectedTab = .home
            }
        } label: {
            Image(systemName: "person")
                .font(.largeTitle)
        }
        .tint(selectedTab == .home ? .white : .black )
    }
    
    var upcomingMovies: some View {
        Button {
            selectedTab = .popularMovies
        } label: {
            Image(systemName: "arrow.up.circle")
                .font(.largeTitle)
        }
        .tint(selectedTab == .popularMovies ? .white : .black )
    }
    
    var nowPlayingMovies: some View {
        Button {
            selectedTab = .nowplayingMovies
        } label: {
            Image(systemName: "play")
                .font(.largeTitle)
        }
        .tint(selectedTab == .nowplayingMovies ? .white : .black)
    }
    
    var extraMovies: some View {
        Button {
            selectedTab = .upcomingMovies
        } label: {
            Image(systemName: "star")
                .font(.largeTitle)
        }
        .tint(selectedTab == .upcomingMovies ? .white : .black )
    }
}

enum CustomTab {
    case home
    case popularMovies
    case upcomingMovies
    case nowplayingMovies
}

#Preview {
    @Previewable @State var selectedTab = CustomTab.home
    CustomTabView(selectedTab: $selectedTab)
}
