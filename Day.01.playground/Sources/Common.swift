import Foundation

//: ## Implementation

//: Possible turns
public enum Turn  {
    case left, right
}

//: Coordinate
public struct Coordinate {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    //: Returns a moved coordinate
    public func moved(length: Int, in orientation: Orientation) -> Coordinate {
        switch orientation {
        case .north: return Coordinate(x: x, y: y + length)
        case .south: return Coordinate(x: x, y: y - length)
        case .west: return Coordinate(x: x - length, y: y)
        case .east: return Coordinate(x: x + length, y: y)
        }
    }
}

//: Possible orientations
public enum Orientation {
    case north, south, east, west
    //: Rotates the orientation
    public func rotate(turn: Turn) -> Orientation {
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
public struct Move {
    public let turn: Turn
    public let length: Int
    
    init(turn: Turn, length: Int) {
        self.turn = turn
        self.length = length
    }
}

//: Describes the position
public struct Position {
    public let coordniate: Coordinate
    public let orientation: Orientation
    
    public init(coordniate: Coordinate, orientation: Orientation) {
        self.coordniate = coordniate
        self.orientation = orientation
    }
    
    //: Perform actual move
    public func walked(_ action: Move) -> Position {
        let orientation = self.orientation.rotate(turn: action.turn)
        let coordinate = self.coordniate.moved(length: action.length, in: orientation)
        return Position(coordniate: coordinate, orientation: orientation)
    }
}
//: ## Helpers

extension Position: CustomStringConvertible {
    public var description: String {
        return "\(coordniate) - \(orientation)"
    }
}

extension Coordinate: CustomStringConvertible {
    public var description: String {
        return "<\(x),\(y)>"
    }
}

extension Move: CustomStringConvertible {
    public var description: String {
        let arrow: String
        switch turn {
        case .left:
            arrow = "⟸"
        case .right:
            arrow = "⟹"
        }
        return "(\(arrow)\(length))"
    }
}

public extension String {
    public func moves() -> [Move] {
        do {
            return try components(separatedBy: ", ").map { try Move(raw: $0) }
        } catch let error {
            print(error)
            return []
        }
    }
}


public extension Move {
    public init(raw: String) throws {
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


public func distanceFromZero(coordinate: Coordinate) -> Int {
    return abs(coordinate.x) + abs(coordinate.y)
}
