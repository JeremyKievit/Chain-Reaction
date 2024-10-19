//
//  TimerVM.swift
//  Chain Reaction
//
//  Created by admin on 10/18/24.
//

import SwiftUI

class TimerVM: ObservableObject {
    @Published private var timeRemaining: TimeInterval
    @Published private var timer: Timer?
    @Published private var isRunning: Bool = false
    @Published var expired: Bool = false
    
    static let startTime: TimeInterval = (0*60) + 30 // Initializing timer
    
    init(timeRemaining: TimeInterval = startTime) {
        self.timeRemaining = timeRemaining
    }
    
    func formattedTime() -> String {
        let minutes = Int(timeRemaining) / 60
        let second = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, second)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                self.expired = true
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        isRunning = false
    }
    
    func resetTimer() {
        stopTimer()
        expired = false
        timeRemaining = TimerVM.startTime
    }
}
