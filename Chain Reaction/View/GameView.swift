//
//  GameView.swift
//  Chain Reaction
//
//  Created by admin on 10/6/24.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameVM: GameVM
    @Environment(\.dismiss) var dismiss
    
    @State var showGameEnd = false
    @State var winner: Players? = nil
    @State var gameIsDisabled = false
    
    @State var showTurnPrompt = false
    @State var nextPlayer: Players? = nil

    
    @StateObject var timer1: TimerVM
    @StateObject var timer2: TimerVM
    
    init(timer1: TimerVM = TimerVM(), timer2: TimerVM = TimerVM()) {
        _timer1 = StateObject(wrappedValue: timer1)
        _timer2 = StateObject(wrappedValue: timer2)
    }
    
    var body: some View {
        ZStack {
            VStack {
                PlayerView(timerVM: timer1, playerScore: $gameVM.player1_score, gameIsDisabled: $gameIsDisabled, player: Players.player1, parent: self)
                    .padding(.init(top: 60, leading: 40, bottom: 0, trailing: 40))
                    .zIndex(2)
                    
                GridView(gameIsDisabled: $gameIsDisabled)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .layoutPriority(1)
                    .zIndex(1)
                    .offset(y: -7)
                                
                PlayerView(timerVM: timer2, playerScore: $gameVM.player2_score, gameIsDisabled: $gameIsDisabled, player: Players.player2, parent: self)
                    .padding(.init(top: 0, leading: 40, bottom: 40, trailing: 40))
                    .zIndex(2)
                    .offset(y: 25)
            }
            .offset(y: -15)
            .background(AppColors.backgroundColor)
            .blur(radius: showGameEnd ? 5 : 0)
            .blur(radius: showGameEnd || showTurnPrompt ? 5 : 0)

            if showGameEnd {
                GameEndView(gameVM: _gameVM, gameIsDisabled: $gameIsDisabled, showGameEnd: $showGameEnd, winner: winner) {
                    resetGame()
                }
                .transition(.scale)
                .zIndex(1)
            }
            
            if showTurnPrompt, let nextPlayer = nextPlayer {
                TurnRequestView(
                    nextPlayer: nextPlayer,
                    playerName: nextPlayer == .player1 ? gameVM.player1_name : gameVM.player2_name,
                    onConfirm: {
                        toggleToNextPlayer()
                        showTurnPrompt = false
                    },
                    onDeny: {
                        restartCurrentTimer()
                        showTurnPrompt = false
                    }
                )
                .transition(.scale)
                .zIndex(2)
            }
            
            if gameIsDisabled {
                Button(action: {
                        dismiss()
                        resetGame()
                    }) {
                        Text("Home")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 35)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 20)
                    .zIndex(3)
            }
        }
        .onAppear(perform: {
            if showGameEnd == false {
                timer1.startTimer()
            }
        })
        .onChange(of: gameIsDisabled) { _ in
            if gameIsDisabled {
                timer1.stopTimer()
                timer2.stopTimer()
            }
        }
        .onChange(of: timer1.expired || timer2.expired) { _ in
            if timer1.expired {
                nextPlayer = .player2
                showTurnPrompt = true
            } else if timer2.expired {
                nextPlayer = .player1
                showTurnPrompt = true
            }
        }
        .onChange(of: gameVM.currentPlayer) { currentPlayer in
            if showGameEnd == true {
                return
            } else if currentPlayer == .player1 {
                print("Changed to player 1")
                timer2.resetTimer()
                timer1.startTimer()
            } else {
                print("Changed to player 1")
                timer1.resetTimer()
                timer2.startTimer()
            }
        }
        .onChange(of: gameVM.gameEnded) { gameEnded in
            if gameEnded {
                if gameVM.player1_score > gameVM.player2_score {
                    winner = .player1
                } else if gameVM.player1_score < gameVM.player2_score {
                    winner = .player2
                } else {
                    winner = nil
                }
                
                handleGameEnd()
            }
        }
        .onChange(of: gameVM.player1_score) { _ in
            if showGameEnd == false {
                timer1.resetTimer()
                timer1.startTimer()
            }
        }
        .onChange(of: gameVM.player2_score) { _ in
            if showGameEnd == false {
                timer2.resetTimer()
                timer2.startTimer()
            }
        }
    }
    
    func toggleToNextPlayer() {
        timer1.resetTimer()
        timer2.resetTimer()
        
        if let nextPlayer = nextPlayer {
            gameVM.currentPlayer = nextPlayer
        }
    }

    func restartCurrentTimer() {
        timer1.resetTimer()
        timer2.resetTimer()
        
        if gameVM.currentPlayer == .player1 {
            timer1.startTimer()
        } else {
            timer2.startTimer()
        }
    }
    
    func handleGameEnd() {
        timer1.stopTimer()
        timer2.stopTimer()
        
        showGameEnd = true
    }
    
    func resetGame() {
        gameVM.resetGame()
        showGameEnd = false
        winner = nil
        
        timer1.resetTimer()
        timer2.resetTimer()
    }
}
