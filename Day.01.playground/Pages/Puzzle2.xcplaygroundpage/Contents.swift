//: [Previous](@previous)

import Foundation

/*:
 # --- Part Two ---
 
 Then, you notice the instructions continue on the back of the Recruiting Document. Easter Bunny HQ is actually at the first location you visit twice.
 
 For example, if your instructions are `R8, R4, R4, R8`, the first location you visit twice is 4 blocks away, due East.
 
 How many blocks away is the __first location you visit twice__?
 
*/

//: ---
//: ## Implementation

extension Coordinate: Equatable { }

public func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
    return lhs.x == rhs.x && rhs.y == lhs.y
}

struct Route {
    let start: Coordinate
    let end: Coordinate
    
    func intersection(_ other: Route) -> Coordinate? {
        guard let x = xRange.lazy.filter({ x in other.xRange.contains(x) }).first,
            let y = yRange.lazy.filter({ y in other.yRange.contains(y) }).first
            else { return nil }
        return Coordinate(x: x, y: y)
    }
    
    init(start: Coordinate, end: Coordinate) {
        self.start = start
        self.end = end
        xRange = CountableClosedRange(uncheckedBounds: (min(start.x, end.x), max(start.x, end.x)))
        yRange =  CountableClosedRange(uncheckedBounds: (min(start.y, end.y), max(start.y, end.y)))
    }

    private  let xRange: CountableClosedRange<Int>
    private let yRange: CountableClosedRange<Int>

}

func firstIntersection(of moves: [Move], from start: Position) -> Coordinate {
    var position = start
    var history = [Route]()
    for move in moves {
        let start = position.coordniate
        position = position.walked(move)
        let end = position.coordniate
        let path = Route(start: start, end: end)
        for route in history {
            if let intersection = path.intersection(route), intersection != path.start {
                return  intersection
            }
        }
        history.append(path)
    }
    return position.coordniate
}

//: ## Execution
let start = Position(coordniate: Coordinate(x: 0, y: 0), orientation: .north)

let sample1 = "R8, R4, R4, R8".moves()
distanceFromZero(coordinate: firstIntersection(of: sample1, from: start)) == 4


//: ---

let input = "L4, L1, R4, R1, R1, L3, R5, L5, L2, L3, R2, R1, L4, R5, R4, L2, R1, R3, L5, R1, L3, L2, R5, L4, L5, R1, R2, L1, R5, L3, R2, R2, L1, R5, R2, L1, L1, R2, L1, R1, L2, L2, R4, R3, R2, L3, L188, L3, R2, R54, R1, R1, L2, L4, L3, L2, R3, L1, L1, R3, R5, L1, R5, L1, L1, R2, R4, R4, L5, L4, L1, R2, R4, R5, L2, L3, R5, L5, R1, R5, L2, R4, L2, L1, R4, R3, R4, L4, R3, L4, R78, R2, L3, R188, R2, R3, L2, R2, R3, R1, R5, R1, L1, L1, R4, R2, R1, R5, L1, R4, L4, R2, R5, L2, L5, R4, L3, L2, R1, R1, L5, L4, R1, L5, L1, L5, L1, L4, L3, L5, R4, R5, R2, L5, R5, R5, R4, R2, L1, L2, R3, R5, R5, R5, L2, L1, R4, R3, R1, L4, L2, L3, R2, L3, L5, L2, L2, L1, L2, R5, L2, L2, L3, L1, R1, L4, R2, L4, R3, R5, R3, R4, R1, R5, L3, L5, L5, L3, L2, L1, R3, L4, R3, R2, L1, R3, R1, L2, R4, L3, L3, L3, L1, L2"
distanceFromZero(coordinate: firstIntersection(of: input.moves(), from: start))

//: ---
//: [Previous](@previous)
