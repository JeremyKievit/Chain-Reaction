//
//  PlayerStartView.swift
//  Chain Reaction
//
//  Created by admin on 10/21/24.
//

import SwiftUI

struct GameStartView: View {
    @EnvironmentObject var gameVM: GameVM
    @State var columns = 2
    var onGameStart: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Player names and grid size")
                    .font(.title2)
                    .foregroundColor(AppColors.matteBlack)
                
                VStack {
                    HStack {
                        Text("Player 1:")
                            .foregroundColor(.black)
                        TextField("Player 1 Name", text: $gameVM.player1_name)
                            .padding()
                            .background(AppColors.player1Color)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Player 2:")
                            .foregroundColor(.black)
                        TextField("Player 2 Name", text: $gameVM.player2_name)
                            .padding()
                            .background(AppColors.player2Color)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Columns: \(columns)")
                            .foregroundColor(.black)
                        Stepper(value: $columns, in: 2...10) {
                            Text("")
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                
                Button(action: {
                    gameVM.columns = columns
                    onGameStart()
                }) {
                    Text("Start Game")
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


