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
    @State var currentTab = 0
    @State var isAnimation = false
    
    var body: some View {
        VStack {
            TabView(selection: $currentTab) {
                ForEach(0..<2) {
                    index in
                    info(index: index)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            indicator
            startButton
        }
    }
    
    private func info(index: Int) -> some View {
        VStack(spacing: 20) {
            Image(viewModel.imageName(index: index))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(isAnimation ? 1.1 : 0.9)
                .animation(.easeIn(duration: 1), value: isAnimation)
            Text(viewModel.info(index: index))
                .font(.system(.title3, design: .rounded))
                .opacity(isAnimation ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: isAnimation)
        }
        .onAppear {
            self.isAnimation = true
        }
    }
    
    private var indicator: some View {
        HStack {
            ForEach(0..<2) {
                index in
                Circle()
                    .fill( index == currentTab ? Color.blue : .gray.opacity(0.3))
                    .frame(width: currentTab == index ? 10 : 8)
                    .animation(.spring, value: currentTab)
            }
        }
    }
    
    private var startButton: some View {
        Button {
            if currentTab < 1 {
                self.isAnimation = false
                self.currentTab += 1
            } else {
                self.isOnboarding = false
            }
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [ Color.blue, Color.blue.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                .overlay {
                    Text(currentTab < 1 ? "Next" : "Start")
                        .foregroundStyle(.white)
                        .bold()
                }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .opacity(isAnimation ? 1 : 0)
    }
}

#Preview {
    OnboardingView()
}
