//
//  LineGesture.swift
//  Chain Reaction
//
//  Created by admin on 8/18/24.
//

//import SwiftUI
//
//struct GridView: View {
//    @State private var dragLocation: CGPoint? // Location of the current drag point
//    @State private var circlePositions: [CGPoint] = [] // Positions of the circles in the grid
//    @State private var lines: [(CGPoint, CGPoint)] = [] // Stores the start and end points of lines drawn between circles
//    @State private var currentLineStartIndex: Int? // Stores the index of the origin point of the current line (the origin point is a member of circlePositions)
//    @State private var spacing: CGFloat = .zero
//    
//    let columns = 5 // Number of columns in the grid
//    let margain: CGFloat = 0 // Can delete margains from everywhere in the code
//    let circleSize: CGFloat = 10
//    let circleColor1 = Color(.black)
//    let circleColor2 = Color(.black)
//    let lineWeight: CGFloat = 10
//    let lineColor = Color(.lightGray)
//    
//    var togglePlayer = true
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                
//                ForEach(0..<circlePositions.count, id: \.self) { index in
//                    Circle()
//                        .frame(width: circleSize, height: circleSize)
//                        .foregroundColor(self.isCircleConnectedOrDragging(index) ? circleColor2 : circleColor1)
//
//                        .position(circlePositions[index])
//                        .zIndex(1)
//                }
//                
//                ForEach(0..<lines.count, id: \.self) { line in
//                    Path { path in
//                        // Generating a line for each point-pair in the lines array
//                        
//                        let startPoint = circlePositions.contains(lines[line].0) ? lines[line].0 : .zero
//                        let endPoint = circlePositions.contains(lines[line].0) ? lines[line].1 : .zero
//                        path.move(to: startPoint)
//                        path.addLine(to: endPoint)
//                    }
//                    .stroke(lineColor, lineWidth: lineWeight)
//                }
//                
//                if let dragLocation = dragLocation, let currentLineStartIndex = currentLineStartIndex {
//                    Path { path in
//                        // Drawing a line between the start circle (currentLineStartIndex) and the current drag location, if both exist
//                        
//                        let startPoint = circlePositions[currentLineStartIndex]
//                        var endPoint = dragLocation
//                        
//                        endPoint = adjustDragPoint(startPoint, endPoint)
//                        
//                        path.move(to: startPoint)
//                        path.addLine(to: endPoint)
//                    }
//                    .stroke(lineColor, lineWidth: lineWeight)
//                }
//            }
//            .onAppear {
//                // Basing the spacing on horizontal space
//                // NOTE: need to consider landscape orientations (horizontal space > vertical space)
//                spacing = (geometry.size.width - margain) / CGFloat(columns + 1)
//                
//                let rows = (geometry.size.height - margain * 1.5) / spacing
//                
//                // Generate positions for all circles in the grid
//                for row in 0..<Int(rows) {
//                    for column in 0..<columns {
//                        let x = CGFloat(column + 1) * spacing + margain/2
//                        let y = CGFloat(row + 1) * spacing + margain/2
//                        circlePositions.append(CGPoint(x: x, y: y))
//                    }
//                }
//                
//                // NOTE: changing circlePositions here triggers the view to re-render (@State)
//            }
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        if self.dragLocation == nil {
//                            let closestCirclePosition = self.closestCirclePosition(to: value.location) ?? .zero
//                            
//                            if let closestCircleIndex = circlePositions.firstIndex(of: closestCirclePosition) {
//                                self.currentLineStartIndex = closestCircleIndex
//                                self.dragLocation = value.location
//                            }
//                            self.dragLocation = value.location
//                        } else {
//                            self.dragLocation = value.location
//                            
////                            self.dragLocation = CGPoint(x: value.location.x, y: closestCirclePosition.x)
//                        }
//                    }
//                    .onEnded { finalLocation in
//                        if let currentLineStartIndex = currentLineStartIndex {
//                            let startPoint = circlePositions[currentLineStartIndex]
//                            var endPoint = closestCirclePosition(to: adjustDragPoint(startPoint, finalLocation.location)) ?? .zero // Final drag point adjusted from drag location
//                            
//                            endPoint = removeDiagnals(of: endPoint, relativeTo: startPoint) // Finding the closest circle that is not on a diagonal
//                            
//                            self.lines.append((startPoint, endPoint))
//                        }
//                        self.dragLocation = nil
//                        self.currentLineStartIndex = nil
//                    }
//            )
//        }
//        .background(.green)
//        .padding(40)
//    }
//}
//
//// MARK: Methods
//
//extension GridView {
//    
//    func isCircleConnectedOrDragging(_ index: Int) -> Bool {
//        let currentDragStart = currentLineStartIndex != nil ? circlePositions[currentLineStartIndex!] : nil
//        return lines.contains(where: { $0.0 == circlePositions[index] || $0.1 == circlePositions[index] }) ||
//               (currentDragStart != nil && (circlePositions[index] == currentDragStart || circlePositions[index] == dragLocation))
//    }
//
//    
//    // Returns the closest circle to a given drag location
//    func closestCirclePosition(to dragLocation: CGPoint) -> CGPoint? {
//        return circlePositions.min(by: {
//            let dist1 = pow(dragLocation.x - $0.x, 2) + pow(dragLocation.y - $0.y, 2)
//            let dist2 = pow(dragLocation.x - $1.x, 2) + pow(dragLocation.y - $1.y, 2)
//            return dist1 < dist2
//        })
//    }
//    
//    // Returns the closest circle that is not on a diagonal (relative to an origin)
//    func removeDiagnals(of endPoint: CGPoint, relativeTo origin: CGPoint) -> CGPoint {
//        if endPoint.x == origin.x || endPoint.y == origin.y {
//            return endPoint
//        }
//        else {
//            return origin
//        }
//    }
//
//    // Returns the distance between two points
//    func distance(between a: CGPoint, _ b: CGPoint) -> CGFloat {
//        return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
//    }
//    
//    // Returns the point-vector for a given line with magnitude reduced to the maximum spacing (when max spacing is exceeded)
//    func adjustDragPoint(_ startPoint: CGPoint, _ endPoint: CGPoint) -> CGPoint {
//        var adjustedEndPoint = endPoint
//        // Ensures that the length of a line is never greater than 'spacing'
//        let maxDist = spacing + circleSize / 2
//        
//        // Check and adjust x-coordinate
//        if abs(startPoint.x - adjustedEndPoint.x) > maxDist {
//            adjustedEndPoint.x = startPoint.x + (startPoint.x - adjustedEndPoint.x < 0 ? maxDist : -maxDist)
//        }
//        
//        // Check and adjust y-coordinate
//        if abs(startPoint.y - adjustedEndPoint.y) > maxDist {
//            adjustedEndPoint.y = startPoint.y + (startPoint.y - adjustedEndPoint.y < 0 ? maxDist : -maxDist)
//        }
//        
//        if distance(between: startPoint, endPoint) > maxDist {
//            // Tracing along the vector when maxDist is exceeded
//            
//            let xDist = startPoint.x - endPoint.x
//            let yDist = startPoint.y - endPoint.y
//            
//            let adjustedXDist = abs(maxDist * cos(atan(yDist / xDist))) // Rcos(θ)
//            let adjustedYDist = abs(maxDist * sin(atan(yDist / xDist))) // Rsin(θ)
//            
//            adjustedEndPoint.x = startPoint.x + (startPoint.x - adjustedEndPoint.x < 0 ? adjustedXDist : -adjustedXDist)
//            adjustedEndPoint.y = startPoint.y + (startPoint.y - adjustedEndPoint.y < 0 ? adjustedYDist : -adjustedYDist)
//        }
//        
//        return adjustedEndPoint
//    }
//}




//struct LineGestureView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridView()
//    }
//}
