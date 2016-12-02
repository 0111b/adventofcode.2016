//: [Next](@next)

import Foundation
/*:
 # --- Day 1: No Time for a Taxicab ---
 
 Santa's sleigh uses a very high-precision clock to guide its movements, and the clock's oscillator is regulated by stars. Unfortunately, the stars have been stolen... by the Easter Bunny. To save Christmas, Santa needs you to retrieve all fifty stars by December 25th.
 
 Collect stars by solving puzzles. Two puzzles will be made available on each day in the advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!
 
 ---
 
 You're airdropped near **Easter Bunny Headquarters** in a city somewhere. "Near", unfortunately, is as close as you can get - the instructions on the Easter Bunny Recruiting Document the Elves intercepted start here, and nobody had time to work them out further.
 
 The Document indicates that you should start at the given coordinates (where you just landed) and face North. Then, follow the provided sequence: either turn left (L) or right (R) 90 degrees, then walk forward the given number of blocks, ending at a new intersection.
 
 There's no time to follow such ridiculous instructions on foot, though, so you take a moment and work out the destination. Given that you can only walk on the [street grid of the city](https://en.wikipedia.org/wiki/Taxicab_geometry), how far is the shortest path to the destination?
 
 For example:
 
 * Following `R2, L3` leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
 * `R2, R2, R2` leaves you 2 blocks due South of your starting position, which is 2 blocks away.
 * `R5, L5, R5, R3` leaves you 12 blocks away.
 
 __How many blocks__ away is Easter Bunny HQ?
 */

//: ## Implementation

//: Possible turns
enum Turn  {
    case left, right
}

//: Coordinate
struct Coordinate {
    let x: Int
    let y: Int
//: Returns a moved coordinate
    func moved(length: Int, in orientation: Orientation) -> Coordinate {
        switch orientation {
        case .north: return Coordinate(x: x, y: y + length)
        case .south: return Coordinate(x: x, y: y - length)
        case .west: return Coordinate(x: x - length, y: y)
        case .east: return Coordinate(x: x + length, y: y)
        }
    }
}

//: Possible orientations
enum Orientation {
    case north, south, east, west
//: Rotates the orientation
    func rotate(turn: Turn) -> Orientation {
        switch self {
        case .north:
            switch turn {
            case .left:
                return .west
            case .right:
                return .east
            }
        case .south:
            switch turn {
            case .left:
                return .east
            case .right:
                return .west
            }
        case .east:
            switch turn {
            case .left:
                return .north
            case .right:
                return .south
            }
        case .west:
            switch turn {
            case .left:
                return .south
            case .right:
                return .north
            }
        }
    }
}

//: Describes the move
struct Move {
    let turn: Turn
    let length: Int
}

//: Describes the position
struct Position {
    let coordniate: Coordinate
    let orientation: Orientation
//: Perform actual move
    func walked(_ action: Move) -> Position {
        let orientation = self.orientation.rotate(turn: action.turn)
        let coordinate = self.coordniate.moved(length: action.length, in: orientation)
        return Position(coordniate: coordinate, orientation: orientation)
    }
}
//: ## Helpers

extension Position: CustomStringConvertible {
    var description: String {
        return "\(coordniate) - \(orientation)"
    }
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "(\(x),\(y))"
    }
}

extension Position {
    func walk(_ moves: [Move]) -> Position {
        return moves.reduce(self) { position, move in
            return position.walked(move)
        }
    }
}

extension String {
    func moves() -> [Move] {
        do {
            return try components(separatedBy: ", ").map { try Move(raw: $0) }
        } catch let error {
            print(error)
            return []
        }
    }
}


extension Move {
    init(raw: String) throws {
        guard raw.characters.count >= 2 else { throw ParsingError.invalidLength }
        let turnString = String(raw[raw.startIndex])
        let lengthString = raw.substring(from: raw.index(after: raw.startIndex))
        guard let parsedLength = Int(lengthString)  else  { throw ParsingError.invalidLength }
        switch turnString {
            case "L": turn = .left
            case "R": turn = .right
            default: throw ParsingError.invalidTurn
        }
        length = parsedLength
    }
    enum ParsingError: Error {
        case invalidString
        case invalidLength
        case invalidTurn
    }
}


//: ## Execution

let start = Position(coordniate: Coordinate(x: 0, y: 0), orientation: .north)

func distanceFromZero(coordinate: Coordinate) -> Int {
    return abs(coordinate.x) + abs(coordinate.y)
}

let sample1 = start.walk("R2, L3".moves())
distanceFromZero(coordinate: sample1.coordniate) == 5
let sample2 = start.walk("R2, R2, R2".moves())
distanceFromZero(coordinate: sample2.coordniate) == 2
let sample3 = start.walk("R5, L5, R5, R3".moves())
distanceFromZero(coordinate: sample3.coordniate) == 12

let input = "L4, L1, R4, R1, R1, L3, R5, L5, L2, L3, R2, R1, L4, R5, R4, L2, R1, R3, L5, R1, L3, L2, R5, L4, L5, R1, R2, L1, R5, L3, R2, R2, L1, R5, R2, L1, L1, R2, L1, R1, L2, L2, R4, R3, R2, L3, L188, L3, R2, R54, R1, R1, L2, L4, L3, L2, R3, L1, L1, R3, R5, L1, R5, L1, L1, R2, R4, R4, L5, L4, L1, R2, R4, R5, L2, L3, R5, L5, R1, R5, L2, R4, L2, L1, R4, R3, R4, L4, R3, L4, R78, R2, L3, R188, R2, R3, L2, R2, R3, R1, R5, R1, L1, L1, R4, R2, R1, R5, L1, R4, L4, R2, R5, L2, L5, R4, L3, L2, R1, R1, L5, L4, R1, L5, L1, L5, L1, L4, L3, L5, R4, R5, R2, L5, R5, R5, R4, R2, L1, L2, R3, R5, R5, R5, L2, L1, R4, R3, R1, L4, L2, L3, R2, L3, L5, L2, L2, L1, L2, R5, L2, L2, L3, L1, R1, L4, R2, L4, R3, R5, R3, R4, R1, R5, L3, L5, L5, L3, L2, L1, R3, L4, R3, R2, L1, R3, R1, L2, R4, L3, L3, L3, L1, L2"
let finalPoint = start.walk(input.moves())
distanceFromZero(coordinate: finalPoint.coordniate)

//: [Next](@next)

