import SwiftUI

struct Node: Identifiable {
    let id: UUID
    let title: String
    let pos: CGPoint
    var isYou: Bool = false
}

@inline(__always)
func formatName(_ p: Person) -> String {
    let fn = p.familyName ?? ""
    let gn = p.givenName ?? ""
    let name = (fn + " " + gn).trimmingCharacters(in: .whitespaces)
    return name.isEmpty ? "(未設定)" : name
}
