//
//  TabView.swift
//  MyMovieApp
//
//  Created by ali cihan on 13.01.2025.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: CustomTab
    @State var isSearchPresented: Bool = false
    
    @Namespace var animation
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Constants.CustomTab.frameColor
                    .frame(height: Constants.CustomTab.frameHeight)
                HStack {
                    catalogue
                    upcomingMovies
                    searchBackground
                    nowPlayingMovies
                    popularMovies
                }
                .frame(height: Constants.CustomTab.height)
                .background(Constants.CustomTab.frameBGColor)
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
                .foregroundStyle(Constants.SearchButton.bgColor)
                .frame(height: Constants.SearchButton.bgRadius)
            Circle()
                .overlay {
                    Image(systemName: "magnifyingglass")
                }
                .foregroundStyle(Constants.SearchButton.color)
                .frame(height: Constants.SearchButton.radius)
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Constants.SearchButton.bgColor)
                .font(Constants.SearchButton.iconFont)
        }
        .matchedTransitionSource(id: "zoom", in: animation)
        .onTapGesture {
            isSearchPresented.toggle()
        }
    }
    
    var searchBackground: some View {
        Circle()
            .fill(.clear)
            .frame(width: Constants.CustomTab.height)
            .frame(maxWidth: .infinity)
    }
    
    var catalogue: some View {
        Button {
            changeTab(to: .catalogue)
        } label: {
            Image(systemName: iconString(name: "movieclapper", for: .catalogue))
                .font(Constants.Icon.font)
        }
        .frame(maxWidth: .infinity)
        .tint(iconColor(tab: .catalogue))
        .shadow(radius: 3)
    }
    
    var upcomingMovies: some View {
        Button {
            changeTab(to: .upcomingMovies)
        } label: {
            Image(systemName: iconString(name: "arrow.up.circle", for: .upcomingMovies))
                .font(Constants.Icon.font)
        }
        .frame(maxWidth: .infinity)
        .tint(iconColor(tab: .upcomingMovies))
    }
    
    var nowPlayingMovies: some View {
        Button {
            changeTab(to: .nowplayingMovies)
        } label: {
            Image(systemName: iconString(name: "play", for: .nowplayingMovies))
                .font(Constants.Icon.font)
        }
        .frame(maxWidth: .infinity)
        .tint(iconColor(tab: .nowplayingMovies))
    }
    
    var popularMovies: some View {
        Button {
            changeTab(to: .popularMovies)
        } label: {
            Image(systemName: iconString(name: "star", for: .popularMovies))
                .font(Constants.Icon.font)
        }
        .frame(maxWidth: .infinity)
        .tint(iconColor(tab: .popularMovies))
    }
    
    private func changeTab(to newTab: CustomTab) {
        selectedTab = newTab
    }
    
    private func iconString(name: String, for tab: CustomTab) -> String {
        if selectedTab == tab {
            return "\(name).fill"
        }
        return name
    }
    
    private func iconColor(tab: CustomTab) -> Color {
        if selectedTab == tab {
            return Constants.Icon.selectedColor
        }
        return Constants.Icon.color
    }
    
    private struct Constants {
        struct Icon {
            static let font: Font = .largeTitle
            static let selectedColor: Color = Color("IconColor")
            static let color: Color = Color("IconColor")
        }
        struct CustomTab {
            static let height: CGFloat = 70
            static let frameHeight: CGFloat = 5
            static let bgOpacity: CGFloat = 0.7
            static let frameColor: Color = Color("IconColor")
            static let frameBGColor: Color = Color("TabBackgroundColor").opacity(0.7)
        }
        
        struct SearchButton {
            static let radius: CGFloat = 80
            static let bgRadius: CGFloat = 90
            static let bgColor: Color = Color("IconColor")
            static let color: Color = .black
            static let iconFont: Font = .largeTitle.bold()
        }
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
