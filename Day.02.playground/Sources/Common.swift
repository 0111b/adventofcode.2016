import Foundation

public func getInput() -> [String] {
    guard let path = Bundle.main.path(forResource: "Input", ofType: "txt"),
        let content = try? String(contentsOfFile: path)
        else { return [] }
    return content.components(separatedBy: .whitespacesAndNewlines)
}
