import SwiftUI

enum Theme {
    static let ink = Color(red: 0.04, green: 0.12, blue: 0.16)
    static let sea = Color(red: 0.00, green: 0.56, blue: 0.61)
    static let moss = Color(red: 0.45, green: 0.68, blue: 0.28)
    static let paper = Color(red: 0.95, green: 0.97, blue: 0.92)
    static let sun = Color(red: 0.96, green: 0.72, blue: 0.24)

    static let background = LinearGradient(colors: [paper, Color(red: 0.84, green: 0.93, blue: 0.91)], startPoint: .topLeading, endPoint: .bottomTrailing)
}
