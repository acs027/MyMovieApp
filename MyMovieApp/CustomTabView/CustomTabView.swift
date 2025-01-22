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
    @State var isSearchPresented: Bool = false
    
    @Namespace var animation
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Color.white
                    .frame(height: 5)
                HStack(spacing: 50) {
                    catalogue
                    upcomingMovies
                    Spacer()
                    nowPlayingMovies
                    popularMovies
                }
                .padding()
                .frame(height: 70)
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.7))
            }
            search
        }
        .fullScreenCover(isPresented: $isSearchPresented) {
            SearchView(animation: animation)
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
        .matchedTransitionSource(id: "zoom", in: animation)
        .onTapGesture {
            isSearchPresented.toggle()
        }
    }
    
    var catalogue: some View {
        Button {
            changeTab(to: .catalogue)
        } label: {
            Image(systemName: "person")
                .font(.largeTitle)
        }
        .tint(selectedTab == .catalogue ? .white : .black )
    }
    
    var upcomingMovies: some View {
        Button {
            changeTab(to: .upcomingMovies)
        } label: {
            Image(systemName: "arrow.up.circle")
                .font(.largeTitle)
        }
        .tint(selectedTab == .upcomingMovies ? .white : .black )
    }
    
    var nowPlayingMovies: some View {
        Button {
            changeTab(to: .nowplayingMovies)
        } label: {
            Image(systemName: "play")
                .font(.largeTitle)
        }
        .tint(selectedTab == .nowplayingMovies ? .white : .black)
    }
    
    var popularMovies: some View {
        Button {
            changeTab(to: .popularMovies)
        } label: {
            Image(systemName: "star")
                .font(.largeTitle)
        }
        .tint(selectedTab == .popularMovies ? .white : .black )
    }
    
    func changeTab(to newTab: CustomTab) {
        selectedTab = newTab
    }
}

enum CustomTab {
    case catalogue
    case popularMovies
    case upcomingMovies
    case nowplayingMovies
}

#Preview {
    @Previewable @State var selectedTab = CustomTab.catalogue
    CustomTabView(selectedTab: $selectedTab)
}
