//
//  GridView.swift
//  Chain Reaction
//
//  Created by admin on 8/27/24.
//

import SwiftUI

struct GridView: View {
    @EnvironmentObject var gameVM: GameVM
    @Binding var gameIsDisabled: Bool
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                // Drawing the background colors for squares
                ForEach(Array(gameVM.squareOwners.keys), id: \.self) { squarePoints in
                    if let player = gameVM.squareOwners[squarePoints] {
                        let points = Array(squarePoints)
                        if points.count == 4 {
                            let sortedPoints = gameVM.sortSquarePoints(points.map { $0.point }) // Sort the points
                            
                            Path { path in
                                path.move(to: sortedPoints[0])
                                path.addLine(to: sortedPoints[1])
                                path.addLine(to: sortedPoints[2])
                                path.addLine(to: sortedPoints[3])
                                path.closeSubpath()
                            }
                            .fill(player.color)
                        }
                    }
                }

                // Adding a circle for each grid point
                ForEach(0..<gameVM.gridPositions.count, id: \.self) { index in
                    Circle()
                        .frame(width: gameVM.circleSize, height: gameVM.circleSize)
                        .foregroundColor(gameVM.isCircleConnectedOrDragging(index) ? AppColors.gridSelectionColor : AppColors.gridColor)
                        .position(gameVM.gridPositions[index])
                        .zIndex(1)
                }

                // Drawing the lines between grid points
                ForEach(Array(gameVM.lines.keys), id: \.self) { startPoint in
                    ForEach(Array(gameVM.lines[startPoint] ?? []), id: \.self) { endPoint in
                        Path { path in
                            path.move(to: startPoint.point)
                            path.addLine(to: endPoint.point)
                        }
                        .stroke(AppColors.lineColor, style: StrokeStyle(lineWidth: gameVM.lineWeight, lineCap: .round))
                    }
                }
                
                if let dragLocation = gameVM.dragLocation, let currentLineStartIndex = gameVM.currentLineStartIndex {
                    Path { path in
                        // Drawing a line between the start circle (currentLineStartIndex) and the current drag location, if both exist
                        
                        let startPoint = gameVM.gridPositions[currentLineStartIndex]
                        var endPoint = dragLocation
                        
                        endPoint = gameVM.adjustDragPoint(startPoint, endPoint)
                        
                        path.move(to: startPoint)
                        path.addLine(to: endPoint)
                    }
                    .stroke(gameVM.lineColor, style: StrokeStyle(lineWidth: gameVM.lineWeight, lineCap: .round))
                }
            }
            .onAppear {
                gameVM.onAppear(geometry: geometry)
            }
            .gesture(
                !gameIsDisabled ? DragGesture()
                    .onChanged { value in
                        gameVM.onDragChanged(value: value)
                    }
                    .onEnded { finalLocation in
                        gameVM.onDragEnded(finalLocation: finalLocation)
                    }
                : nil
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.backgroundColor)
        .padding(.horizontal)
    }
}
