//
//  LaunchScreenAnimation.swift
//  MyMovieApp
//
//  Created by ali cihan on 3.12.2024.
//

import SwiftUI

struct LaunchScreenAnimation: View {
    @State var imageSize = UIScreen.main.bounds.width
    @State var rotationDegree: Double = 0
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.white
            Image("MovieAppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .rotationEffect(Angle(degrees: rotationDegree), anchor: UnitPoint(x: 0.5, y: 0))
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 3)) {
                imageSize = 0
                rotationDegree = 360
            } completion: {
                isPresented.toggle()
            }
        }
    }
}

#Preview {
    @Previewable @State var isPresented = true
    LaunchScreenAnimation(isPresented: $isPresented)
}
