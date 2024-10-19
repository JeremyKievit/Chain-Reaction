//
//  ContentView.swift
//  Drag Gesture Practice (1)
//
//  Created by admin on 8/17/24.
//

import SwiftUI

struct ContentView: View {
    @GestureState var locationState = CGPoint(x: 100, y: 100)
    @State var location = CGPoint(x: 100, y: 100)

    var body: some View {
        VStack {
//            Color.green
//                .frame(height: 200)
            Circle()
                .fill(.red)
                .frame(width: 100, height: 100)
//                .position(locationState)
                .position(location)
                .gesture(
                    DragGesture(
                        minimumDistance: 200,
                        coordinateSpace: .local
                    )
                        .onChanged { state in
                            self.location = state.location
                        }
                        .onEnded { state in
                            withAnimation {
                                self.location = state.location

                            }
                        }
                        .updating(
                            self.$locationState
                        ) { currentState, pastLocation, transaction  in
                            pastLocation = currentState.location
                            transaction.animation = .easeInOut
                        }

                )
        }
    }
}

#Preview {
    ContentView()
}
