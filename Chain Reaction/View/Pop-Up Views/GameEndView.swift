//
//  Untitled.swift
//  Chain Reaction
//
//  Created by admin on 10/16/24.
//

import SwiftUI

struct GameEndView: View {
    @EnvironmentObject var gameVM: GameVM
    @Environment(\.dismiss) var dismiss
    
    @Binding var gameIsDisabled: Bool
    @Binding var showGameEnd: Bool
    
    var winner: Players?
    var onReset: () -> Void
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 20) {
                if let winner = winner {
                    Text("\(winner == Players.player1 ? gameVM.player1_name : gameVM.player2_name) Wins!")
                        .font(.largeTitle)
                        .foregroundColor(AppColors.matteBlack)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Game is tied")
                        .font(.largeTitle)
                        .foregroundColor(AppColors.matteBlack)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    onReset()
                    dismiss()
                }) {
                    Text("Home")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    gameIsDisabled = true
                    showGameEnd = false
                }) {
                    Text("View Game")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
            .frame(maxWidth: 300)
        }
    }
}
