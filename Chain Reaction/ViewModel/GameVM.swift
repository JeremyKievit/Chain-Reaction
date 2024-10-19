
import SwiftUI

// MARK: Properties

import SwiftUI

class GameVM: ObservableObject {
    
    // Grid Properties
    
    @Published var dragLocation: CGPoint? // Location of the current drag point
    @Published var gridPositions: [CGPoint] = [] // Positions of the circles in the grid
    @Published var lines: [HashablePoint: Set<HashablePoint>] = [:] // Stores hashable start and end points of lines drawn between circles
    @Published var squares: [HashablePoint: Set<HashablePoint>] = [:] // Stores hashable positions of all lines that form squares
    @Published var currentLineStartIndex: Int? // Stores the index of the origin point of the current line (the origin point is a member of gridPositions)
    @Published var spacing: CGFloat = .zero
    
    let lineColor = AppColors.lineColor
    
    var columns: Int // Number of columns in the grid
    
    var circleSize: CGFloat {
        return 180 / CGFloat(columns) <= 30 ? 180 / CGFloat(columns) : 30
    }
    
    var lineWeight: CGFloat {
        return 2 * circleSize / 3
    }
    
    // Player Properties
    
    @Published var player1_name: String
    @Published var player2_name: String
    @Published var currentPlayer = Players.player1
    @Published var player1_score: Int = 0
    @Published var player2_score: Int = 0
    @Published var squareOwners: [Set<HashablePoint>: Players] = [:] // Maps each square (defined by four points) to the player who completed it
    
    init(player1Name: String = "Player 1", player2Name: String = "Player 2", columns: Int = 6) {
            self.player1_name = player1Name
            self.player2_name = player2Name
            self.columns = columns
    }
    
    // Game Properties
    
    @Published var gameEnded = false
}

// MARK: Methods

extension GameVM: GameProtocol { // NOTE: Each method is explained in the game protocol
    
    func initiateGameEnd() { // NOTE: Game end is only initiated when the grid is filled
        gameEnded = true
    }
    
    func resetGame() {
        gridPositions.removeAll()
        lines.removeAll()
        squares.removeAll()
        squareOwners.removeAll()
        currentLineStartIndex = nil
        player1_score = 0
        player2_score = 0
        currentPlayer = .player1
        gameEnded = false
    }
    
    func togglePlayers() {
        currentPlayer = (currentPlayer == .player1 ? .player2 : .player1)
    }
    
    func isCircleConnectedOrDragging(_ index: Int) -> Bool {
        let currentDragStart = currentLineStartIndex != nil ? gridPositions[currentLineStartIndex!] : nil
        return lines.contains(where: { (startPoint, endPoints) in
            // Check if the start point or any of its associated endpoints match the grid position
            startPoint.point == gridPositions[index] ||
            endPoints.contains(where: { $0.point == gridPositions[index] })
        }) || (currentDragStart != nil &&
               (gridPositions[index] == currentDragStart || gridPositions[index] == dragLocation))
    }
    
    func closestCirclePosition(to dragLocation: CGPoint) -> CGPoint? {
        return gridPositions.min(by: {
            let dist1 = pow(dragLocation.x - $0.x, 2) + pow(dragLocation.y - $0.y, 2)
            let dist2 = pow(dragLocation.x - $1.x, 2) + pow(dragLocation.y - $1.y, 2)
            return dist1 < dist2
        })
    }
    
    func isDiagonal(_ startPoint: CGPoint, _ endPoint: CGPoint) -> Bool {
        if endPoint.x == startPoint.x || endPoint.y == startPoint.y {
            return false
        } else {
            return true
        }
    }
    
    func distance(between a: CGPoint, _ b: CGPoint) -> CGFloat {
        return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
    }
    
    func adjustDragPoint(_ startPoint: CGPoint, _ endPoint: CGPoint) -> CGPoint {
        var adjustedEndPoint = endPoint
        // Ensures that the length of a line is never greater than 'spacing'
        let maxDist = spacing + circleSize / 2
        
        // Check and adjust x-coordinate
        if abs(startPoint.x - adjustedEndPoint.x) > maxDist {
            adjustedEndPoint.x = startPoint.x + (startPoint.x - adjustedEndPoint.x < 0 ? maxDist : -maxDist)
        }
        
        // Check and adjust y-coordinate
        if abs(startPoint.y - adjustedEndPoint.y) > maxDist {
            adjustedEndPoint.y = startPoint.y + (startPoint.y - adjustedEndPoint.y < 0 ? maxDist : -maxDist)
        }
        
        if distance(between: startPoint, endPoint) > maxDist {
            // Tracing along the vector when maxDist is exceeded
            
            let xDist = startPoint.x - endPoint.x
            let yDist = startPoint.y - endPoint.y
            
            let adjustedXDist = abs(maxDist * cos(atan(yDist / xDist))) // Rcos(θ)
            let adjustedYDist = abs(maxDist * sin(atan(yDist / xDist))) // Rsin(θ)
            
            adjustedEndPoint.x = startPoint.x + (startPoint.x - adjustedEndPoint.x < 0 ? adjustedXDist : -adjustedXDist)
            adjustedEndPoint.y = startPoint.y + (startPoint.y - adjustedEndPoint.y < 0 ? adjustedYDist : -adjustedYDist)
        }
        
        return adjustedEndPoint
    }
    
    func onAppear(geometry: GeometryProxy) {
        // Spacing is based on the horizontal space
        spacing = geometry.size.width / CGFloat(columns + 1)
        
        let rows = geometry.size.height / spacing
        
        // Setting general positions for all circles in the grid
        for row in 0..<Int(rows) {
            for column in 0..<columns {
                let x = CGFloat(column + 1) * spacing
                let y = CGFloat(row + 1) * spacing
                gridPositions.append(CGPoint(x: x, y: y))
            }
        }
        
        // NOTE: changing gridPositions here triggers the view to re-render (@Published)
    }
    
    func onDragChanged(value: DragGesture.Value) {
        if dragLocation == nil {
            let closestCirclePosition = closestCirclePosition(to: value.location) ?? .zero
            
            if let closestCircleIndex = gridPositions.firstIndex(of: closestCirclePosition) {
                currentLineStartIndex = closestCircleIndex
                dragLocation = value.location
            }
            dragLocation = value.location
        } else {
            dragLocation = value.location
        }
    }
    
    func onDragEnded(finalLocation: DragGesture.Value) {
        if let currentLineStartIndex = currentLineStartIndex {
            let startPoint = gridPositions[currentLineStartIndex]
            guard let endPoint = closestCirclePosition(to: adjustDragPoint(startPoint, finalLocation.location)) else {
                return
            }

            if startPoint != endPoint && !isDiagonal(startPoint, endPoint) {
                let startHashable = HashablePoint(point: startPoint)
                let endHashable = HashablePoint(point: endPoint)
                
                // Checking if the new line already exists (in either direction)
                if lines[startHashable]?.contains(endHashable) == true || lines[endHashable]?.contains(startHashable) == true {
                    return
                }
                
                // Add both directions for undirected graph
                lines[startHashable, default: []].insert(endHashable)
                lines[endHashable, default: []].insert(startHashable)

                // Check if the new line forms a square
                if containsNewSquare(from: (startHashable, endHashable)) {
                    if currentPlayer == Players.player1 {
                        player1_score += 1
                    } else if currentPlayer == Players.player2 {
                        player2_score += 1
                    }
                } else {
                    togglePlayers()
                }
                
                if gridIsFilled() {
                    initiateGameEnd()
                }
            }
        }
        dragLocation = nil
        currentLineStartIndex = nil
    }
    
    func containsNewSquare(from newLine: (HashablePoint, HashablePoint)) -> Bool {
        let (startPoint, endPoint) = newLine
        var foundSquare = false

        // Get all lines connected to the start and end points
        let connectedToStart = lines[startPoint] ?? Set()
        let connectedToEnd = lines[endPoint] ?? Set()

        for pointX in connectedToStart {
            if pointX == endPoint { continue } // Skip the current line

            for pointY in connectedToEnd {
                if pointY == startPoint { continue } // Skip the current line

                // Check if pointX and pointY are connected (this completes a square)
                if lines[pointX]?.contains(pointY) == true || lines[pointY]?.contains(pointX) == true {
                    foundSquare = true
                    
                    // Mark this square as owned by the current player
                    let squarePoints: Set<HashablePoint> = [startPoint, endPoint, pointX, pointY]
                    squareOwners[squarePoints] = currentPlayer
                }
            }
        }

        return foundSquare
    }
    
    func gridIsFilled() -> Bool {
        // The number of grid rows in the grid is calculated by dividing the total number of grid positions by the number of columns.
        let circleRows = Int(gridPositions.count / columns)

       // The number of vertical line rows is the number of grid rows minus 1
        let vLineRows = circleRows - 1

        // The number of horizontal line rows is the number of grid rows
        let hLineRows = circleRows

        // The number of line columns is the number of grid columns minus 1
        let lineCols = columns - 1

        // The purpose of this section is to calculate the number of vertical lines possible in the grid.
        // We have (vLineRows) rows, and each row has 'lineCols' number of vertical lines.
        let verticalLines = columns * vLineRows

        // The purpose of this section is to calculate the number of horizontal lines possible in the grid.
        // We have 'hLineRows' complete rows of horizontal lines and each row has 'lineCols' number of horizontal lines (excluding the endpoints).
        let horizontalLines = hLineRows * lineCols

        // The total number of possible lines in the grid = Number of vertical lines + Number of horizontal lines
        let totalPossibleLines = verticalLines + horizontalLines
        
        filterLines()
        
        return lineCount() == totalPossibleLines
    }
    
    func filterLines() {
        for (startPoint, endPoints) in lines {
            lines[startPoint] = endPoints.filter { $0.point != startPoint.point }
        }
    }
    
    func lineCount() -> Int {
        var countedLines = Set<HashablePoint>()
        var totalLines = 0

        for (startPoint, endPoints) in lines {
            for endPoint in endPoints {
                if !countedLines.contains(endPoint) {
                    totalLines += 1
                }
            }
            countedLines.insert(startPoint)
        }

        return totalLines
    }
    
    func sortSquarePoints(_ points: [CGPoint]) -> [CGPoint] {
        guard points.count == 4 else { return points }
        
        let sortedPoints = points.sorted { (p1, p2) -> Bool in
            if p1.x == p2.x {
                return p1.y < p2.y
            }
            return p1.x < p2.x
        }
        
        let topLeft = sortedPoints[0]
        let bottomLeft = sortedPoints[1]
        let topRight = sortedPoints[2]
        let bottomRight = sortedPoints[3]
        
        return [topLeft, topRight, bottomRight, bottomLeft]
    }
}
