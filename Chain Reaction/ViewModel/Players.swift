//
//  File.swift
//  Chain Reaction
//
//  Created by admin on 8/27/24.
//

import SwiftUI

enum Players {
    case player1
    case player2
    
    // Player name
    var name: String {
       switch self {
       case .player1:
           return GameVM().player1_name
       case .player2:
           return GameVM().player2_name
       }
   }
    
    
    // Player image
    var image: String {
        switch self {
        case .player1:
            return "squirrel_icon"
        case .player2:
            return "otter_icon"
        }
    }
    
    // Player colors
    var color: Color {
        switch self {
        case .player1:
            return AppColors.player1Color
        case .player2:
            return AppColors.player2Color
        }
    }
}
