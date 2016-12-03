import Foundation

public func getInput() -> [String] {
    guard let path = Bundle.main.path(forResource: "Input", ofType: "txt"),
        let content = try? String(contentsOfFile: path)
        else { return [] }
    return content.components(separatedBy: .whitespacesAndNewlines)
}

public enum Move: Character {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"
}

public typealias MoveSequence = [[Move]]

public func getInputMoves() -> MoveSequence {
    return getInput().map({ string in
        return string.characters.map { Move(rawValue: $0)}.flatMap { $0 }
    }).filter { $0.count > 0 }
}


public struct Button {
    public init(_ value: String) {
        self.value = value
    }
    public let value: String
}

public class Desk {
    public typealias Row = Array<Button>
    
    public init?(buttons: [Row], startX: Int, startY: Int) {
        cursor =  Cursor(x: startX, y: startY)
        field = buttons
        maxY = field.count
        guard let row = field.first else { return  nil }
        maxX = row.count
        guard startX >= 0 && startY >= 0 && startX <= maxX && maxY <= maxY else { return nil }
    }
    
    public func move(_ action: Move) {
        switch  action {
        case .left where  cursor.x - 1 >= 0:
            cursor.x -= 1
        case .right where cursor.x + 1 < maxX:
            cursor.x += 1
        case .up where cursor.y - 1  >= 0:
            cursor.y -= 1
        case .down where cursor.y + 1 < maxY:
            cursor.y += 1
        default:
            return
        }
    }
    
    public var selectedButton: Button {
        return field[cursor.y][cursor.x]
    }
    
    struct  Cursor {
        var x: Int
        var y: Int
    }
    
    let maxX: Int
    let maxY: Int
    let field: [Row]
    var cursor: Cursor
}


extension Desk.Cursor: Equatable { }

func ==(lhs: Desk.Cursor, rhs: Desk.Cursor) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}


extension Desk: CustomStringConvertible {
    public var description: String {
        var desc = ""
        for (y, row) in field.enumerated() {
            for (x, cell) in row.enumerated() {
                if cursor == Cursor(x: x, y: y) {
                    desc.append("<\(cell.value)>")
                } else {
                    desc.append(" \(cell.value) ")
                }
            }
            desc.append("|")
        }
        return desc
    }
}

