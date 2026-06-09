import Foundation

enum Track: String, CaseIterable, Identifiable, Codable {
    case mainTrack1 = "Main Track 1"
    case mainTrack2 = "Main Track 2"
    case sovereignty = "Sovereignty Track"
    case sponsor = "Sponsor Track"

    var id: String { rawValue }

    var room: String {
        switch self {
        case .mainTrack1: "ABATON B"
        case .mainTrack2: "ABATON A"
        case .sovereignty: "ABATON 4"
        case .sponsor: "ABATON 3"
        }
    }
}

enum Difficulty: String, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case sponsorTalk = "Sponsor Talk"
}

struct Speaker: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let imageURL: URL?
}

struct Session: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let start: DateComponents
    let durationMinutes: Int
    let track: Track
    let speakers: [Speaker]
    let difficulties: [Difficulty]
    let summary: String

    var timeRange: String {
        guard let hour = start.hour, let minute = start.minute else { return "" }
        let totalStart = hour * 60 + minute
        let totalEnd = totalStart + durationMinutes
        return "\(Self.format(minutes: totalStart)) - \(Self.format(minutes: totalEnd))"
    }

    var speakerLine: String {
        speakers.map(\.name).joined(separator: ", ")
    }

    private static func format(minutes: Int) -> String {
        String(format: "%02d:%02d", minutes / 60, minutes % 60)
    }
}
