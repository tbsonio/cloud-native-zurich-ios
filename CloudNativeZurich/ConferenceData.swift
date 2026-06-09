import Foundation
import SwiftUI

enum ConferenceData {
    static let eventDate = "11 June, 2026"
    static let venue = "Abaton, Zurich"
    static let sessionizeToken = "uig536s9"
    static let sessionizeURL = URL(string: "https://cloud-native-zurich-2026.sessionize.com/")!
    static let websiteURL = URL(string: "https://cloudnativezurich.ch/schedule/")!

    static let sessionsAPI = URL(string: "https://sessionize.com/api/v2/\(sessionizeToken)/view/GridSmart")!
    static let speakersAPI = URL(string: "https://sessionize.com/api/v2/\(sessionizeToken)/view/Speakers")!
}

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var sessions: [Session] = []
    @Published private(set) var speakers: [Speaker] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    func load() async {
        guard sessions.isEmpty else { return }
        isLoading = true
        errorMessage = nil

        do {
            async let gridResponse = fetch([SessionizeGridDay].self, from: ConferenceData.sessionsAPI)
            async let speakerResponse = fetch([SessionizeSpeaker].self, from: ConferenceData.speakersAPI)
            let (gridDays, apiSpeakers) = try await (gridResponse, speakerResponse)
            let speakerMap = Dictionary(uniqueKeysWithValues: apiSpeakers.map { ($0.id, $0.toSpeaker()) })
            let mappedSessions = gridDays.flatMap { day in
                day.rooms.flatMap { room in
                    room.sessions.map { $0.toSession(roomName: room.name, speakerMap: speakerMap) }
                }
            }
            sessions = mappedSessions.sorted { $0.startsAt == $1.startsAt ? $0.room < $1.room : $0.startsAt < $1.startsAt }
            speakers = Array(Set(mappedSessions.flatMap(\.speakers))).sorted { $0.name < $1.name }
        } catch {
            errorMessage = "Could not load the Sessionize schedule. \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

private struct SessionizeGridDay: Decodable {
    let rooms: [SessionizeRoom]
}

private struct SessionizeRoom: Decodable {
    let name: String
    let sessions: [SessionizeSession]
}

private struct SessionizeSession: Decodable {
    let id: String
    let title: String
    let description: String?
    let startsAt: String
    let endsAt: String
    let isServiceSession: Bool
    let speakers: [SessionizeSpeakerReference]
    let categories: [SessionizeCategory]
    let liveUrl: URL?
    let recordingUrl: URL?

    func toSession(roomName: String, speakerMap: [String: Speaker]) -> Session {
        let start = Date.sessionize(startsAt)
        let end = Date.sessionize(endsAt)
        return Session(
            id: id,
            title: title,
            startsAt: start,
            endsAt: end,
            durationMinutes: Calendar.current.dateComponents([.minute], from: start, to: end).minute ?? 0,
            track: Track.from(room: roomName),
            room: roomName,
            speakers: speakers.map { reference in
                speakerMap[reference.id] ?? Speaker(id: reference.id, name: reference.name, tagline: "", bio: "", imageURL: nil, links: [])
            },
            categories: categories.flatMap { category in category.categoryItems.map(\.name) },
            summary: description?.normalizedWhitespace ?? "Schedule item for Cloud Native Zurich 2026.",
            isServiceSession: isServiceSession,
            liveURL: liveUrl,
            recordingURL: recordingUrl
        )
    }
}

private struct SessionizeSpeakerReference: Decodable {
    let id: String
    let name: String
}

private struct SessionizeCategory: Decodable {
    let categoryItems: [SessionizeCategoryItem]
}

private struct SessionizeCategoryItem: Decodable {
    let name: String
}

private struct SessionizeSpeaker: Decodable {
    let id: String
    let fullName: String
    let bio: String?
    let tagLine: String?
    let profilePicture: URL?
    let links: [SessionizeSpeakerLink]

    func toSpeaker() -> Speaker {
        Speaker(
            id: id,
            name: fullName,
            tagline: tagLine ?? "",
            bio: bio?.normalizedWhitespace ?? "",
            imageURL: profilePicture,
            links: links.map { SpeakerLink(title: $0.title, url: $0.url) }
        )
    }
}

private struct SessionizeSpeakerLink: Decodable {
    let title: String
    let url: URL?
}

private extension String {
    var normalizedWhitespace: String {
        components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
