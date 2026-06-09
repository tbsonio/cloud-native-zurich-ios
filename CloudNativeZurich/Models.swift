import Foundation

enum Track: String, CaseIterable, Identifiable, Codable {
    case mainTrack1 = "Main Track 1"
    case mainTrack2 = "Main Track 2"
    case sovereignty = "Sovereignty Track"
    case sponsor = "Sponsor Track"

    var id: String { rawValue }

    var room: String {
        switch self {
        case .mainTrack1: "Abaton B"
        case .mainTrack2: "Abaton A"
        case .sovereignty: "Abaton 4"
        case .sponsor: "Abaton 3"
        }
    }

    static func from(room: String) -> Track {
        if room.localizedCaseInsensitiveContains("Abaton A") { return .mainTrack2 }
        if room.localizedCaseInsensitiveContains("Abaton 4") { return .sovereignty }
        if room.localizedCaseInsensitiveContains("Sponsor") || room.localizedCaseInsensitiveContains("Abaton 3") { return .sponsor }
        return .mainTrack1
    }
}

struct SpeakerLink: Hashable, Codable {
    let title: String
    let url: URL?
}

struct Speaker: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let tagline: String
    let bio: String
    let imageURL: URL?
    let links: [SpeakerLink]
}

struct Session: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let startsAt: Date
    let endsAt: Date
    let durationMinutes: Int
    let track: Track
    let room: String
    let speakers: [Speaker]
    let categories: [String]
    let summary: String
    let isServiceSession: Bool
    let liveURL: URL?
    let recordingURL: URL?

    var timeRange: String {
        "\(Self.timeFormatter.string(from: startsAt)) - \(Self.timeFormatter.string(from: endsAt))"
    }

    var speakerLine: String {
        speakers.map(\.name).joined(separator: ", ")
    }

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

extension DateFormatter {
    static let sessionizeLocalDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
}

extension Date {
    static func sessionize(_ value: String) -> Date {
        DateFormatter.sessionizeLocalDateTime.date(from: value) ?? .distantPast
    }
}
