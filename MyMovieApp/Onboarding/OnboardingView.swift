//
//  OnboardingView.swift
//  MyMovieApp
//
//  Created by ali cihan on 2.12.2024.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel = OnboardingViewModel()
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        TabView {
            ForEach(0..<2) {
                index in
                infoView(index: index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
    
    private func infoView(index: Int) -> some View {
        VStack {
            Text(viewModel.info(index: index))
            Image(viewModel.imageName(index: index))
                .resizable()
                .frame(width: 40, height: 40)
                .scaledToFit()
            startButton
        }
    }
    
    private var startButton: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(lineWidth: 1)
            .overlay {
                HStack {
                    Text("Start")
                    Image(systemName: "arrow.right.circle")
                }
            }
            .frame(width: 80, height: 40)
            .onTapGesture {
                isOnboarding = false
            }
    }
}

#Preview {
    OnboardingView()
}
