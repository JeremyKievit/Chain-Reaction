//
//  TurnRequestView.swift
//  Chain Reaction
//
//  Created by admin on 10/22/24.
//

import SwiftUI

struct TurnRequestView: View {
    var nextPlayer: Players
    var playerName: String
    var onConfirm: () -> Void
    var onDeny: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("\(playerName), would you like to take your turn?")
                    .font(.title2)
                    .foregroundColor(AppColors.matteBlack)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 20) {
                    Button(action: {
                        onConfirm()
                    }) {
                        Text("Yes")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        onDeny()
                    }) {
                        Text("No")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
            .frame(maxWidth: 300)
        }
        .padding(.horizontal, 20)
    }
}

