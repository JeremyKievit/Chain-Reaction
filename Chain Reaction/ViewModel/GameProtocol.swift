//
//  GameProtocol.swift
//  Chain Reaction
//
//  Created by admin on 8/27/24.
//

import SwiftUI

protocol GameProtocol {
    
    // Triggers the game end logic in the GameView
    func initiateGameEnd()
    
    // Deletes all grid and player data
    func resetGame()
    
    // Toggle between players in the player view
    func togglePlayers()
    
    // Checks if a grid point is associated with a line (either dragging or part of the lines array)
    func isCircleConnectedOrDragging(_ index: Int) -> Bool
    
    // Returns the closest grid point to a given drag location
    func closestCirclePosition(to dragLocation: CGPoint) -> CGPoint?
    
    // Returns true if the two grid points are on a diagonal
    func isDiagonal(_ startPoint: CGPoint, _ endPoint: CGPoint) -> Bool
    
    // Returns the distance between two grid points
    func distance(between a: CGPoint, _ b: CGPoint) -> CGFloat
    
    // Returns the point-vector for a given line with magnitude reduced to the maximum spacing (when max spacing is exceeded)
    func adjustDragPoint(_ startPoint: CGPoint, _ endPoint: CGPoint) -> CGPoint
    
    // Sets the spacing and positioning for the grid points
    func onAppear(geometry: GeometryProxy)
    
    // Continually updates the closest grid position to the drag location
    func onDragChanged(value: DragGesture.Value)
    
    // Finds the closest grid point to the drag location and creates a new line from the origin to that point if the points are not equal or diagonal, and if the line does not already exist
    func onDragEnded(finalLocation: DragGesture.Value)
    
    // Returns true if a new square was added to the grid
    func containsNewSquare(from newLine: (HashablePoint, HashablePoint)) -> Bool
    
    // Performs a set of calculations to determine if the lines fill up all available space
    func gridIsFilled() -> Bool
    
    // Removes any endpoint in the lines dictionary that matches its start point
    func filterLines()
    
    // Counts the number of undirected lines in the grid
    func lineCount() -> Int
    
    // Sorts a set of four neighboring grid points into the order that they appear on the grid (top-left, top-right, bottom-right, and bottom-left)
    func sortSquarePoints(_ points: [CGPoint]) -> [CGPoint]
}

