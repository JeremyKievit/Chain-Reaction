//
//  PlayerView.swift
//  Chain Reaction
//
//  Created by admin on 8/27/24.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var gameVM: GameVM
    @StateObject var timerVM: TimerVM
    
    @Binding var playerScore: Int
    @Binding var gameIsDisabled: Bool
    
    let player: Players
    let parent: GameView
    
    @State private var isRotated = false
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                PlayerImageView(player: player, playerImage: player.image, playerColor: player.color)
                    .frame(width: 60, height: 60)
                    .fixedSize()
                    .padding(.trailing, 20)

                VStack(alignment: .leading, spacing: 5) {
                    Text(player == .player1 ? gameVM.player1_name : gameVM.player2_name)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(width: 100, alignment: .leading)
                    
                    HStack(spacing: 5) {
                        Rectangle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(player.color)
                            .cornerRadius(4)
                        
                        Text(String(playerScore))
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                            .lineLimit(1)
                            .frame(width: 50, alignment: .leading)
                    }
                }
                .padding(.leading, 0)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(AppColors.matteBlack)
                        .cornerRadius(10)
                        .frame(width: 130, height: 45)

                    HStack {
                        Image("clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        
                        Text(timerVM.formattedTime())
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .lineLimit(1)
                            .fixedSize()
                    }
                }
                .padding(.trailing, 10)
                
                VStack(spacing: 10) {
                    // Rotate button
                    Button(action: {
                        withAnimation {
                            isRotated.toggle()
                        }
                    }) {
                        Image(systemName: "arrow.2.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                    
                    // Forfeit Button
                    Button(action: {
                        if !gameIsDisabled {
                            if player == .player1 {
                                parent.winner = .player2
                            } else if player == .player2 {
                                parent.winner = .player1
                            }
                            parent.handleGameEnd()
                        }
                    }) {
                        Image(systemName: "flag.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .rotationEffect(.degrees(isRotated ? 180 : 0))
        }
    }
}
