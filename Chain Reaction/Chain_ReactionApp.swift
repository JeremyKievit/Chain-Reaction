//
//  Chain_ReactionApp.swift
//  Chain Reaction
//
//  Created by admin on 8/16/24.
//

import SwiftUI

@main
struct Chain_ReactionApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(GameVM())
        }
    }
}
