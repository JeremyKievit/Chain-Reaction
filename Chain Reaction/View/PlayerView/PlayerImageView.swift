//
//  PlayerImageView.swift
//  Chain Reaction
//
//  Created by admin on 10/10/24.
//

import SwiftUI

struct PlayerImageView: View {
    @EnvironmentObject var gameVM: GameVM
    
    var player: Players
    var playerImage: String
    var playerColor: Color
    
    var body: some View {
        Image(playerImage)
            .resizable()
            .scaledToFill()
            .padding(7)
            .background(Circle().fill(Color.white))
            .clipShape(Circle())
            .overlay(
                Group {
                    if gameVM.currentPlayer == player {
                        Circle()
                            .stroke(player.color, lineWidth: 5)
                    } else {
                        Circle()
                            .stroke(AppColors.matteBlack, lineWidth: 4)
                    }
                }
            )
    }
}
