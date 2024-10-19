//
//  LandingPageView.swift
//  Chain Reaction
//
//  Created by admin on 8/31/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isGamePresented = false
    @State private var showNameEntry = false
    @StateObject private var gameVM = GameVM()

    var body: some View {
        ZStack {
            AppColors.backgroundColor
                .ignoresSafeArea()
            
            BackgroundCircles()

            VStack(spacing: 40) {
                Image("Icon_Clear")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)

                VStack(spacing: 10) {
                    Text("Welcome to")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.white)
                        .opacity(showNameEntry ? 0.5 : 1.0)

                    Text("Chain Reaction")
                        .font(.system(size: 45, weight: .black))
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center)

                Button(action: {
                    showNameEntry = true
                }) {
                    Text("Play Now")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                                                   startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                        .shadow(color: Color.white.opacity(0.8), radius: 10, x: 0, y: 0)
                }
                .padding(.horizontal, 40)
            }
            .padding(.bottom, 100)
            .blur(radius: showNameEntry ? 5 : 0)

            if showNameEntry {
                GameStartView(onGameStart: startGame)
                    .environmentObject(gameVM)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .fullScreenCover(isPresented: $isGamePresented) {
            GameView()
                .environmentObject(gameVM)
        }
    }

    private func startGame() {
        isGamePresented = true
        showNameEntry = false
    }
}

struct BackgroundCircles: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 300, height: 300)
                .offset(x: -150, y: -300)
                .scaleEffect(animate ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)

            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 200, height: 200)
                .offset(x: 180, y: 250)
                .scaleEffect(animate ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
        }
        .onAppear {
            self.animate = true
        }
    }
}





