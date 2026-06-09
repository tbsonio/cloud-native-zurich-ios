import SwiftUI

struct ScheduleView: View {
    let sessions: [Session]
    let isLoading: Bool
    let errorMessage: String?
    @Binding var selectedTrack: Track?
    @Binding var searchText: String
    let favoriteSessionIDs: Set<String>
    let toggleFavorite: (Session) -> Void

    private var filteredSessions: [Session] {
        sessions.filter { session in
            let matchesTrack = selectedTrack == nil || session.track == selectedTrack
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let matchesSearch = query.isEmpty
                || session.title.localizedCaseInsensitiveContains(query)
                || session.summary.localizedCaseInsensitiveContains(query)
                || session.speakerLine.localizedCaseInsensitiveContains(query)
                || session.categories.contains { $0.localizedCaseInsensitiveContains(query) }
            return matchesTrack && matchesSearch
        }
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HeroHeader()
                    TrackPicker(selectedTrack: $selectedTrack)
                    LazyVStack(spacing: 12) {
                        if isLoading && sessions.isEmpty {
                            ProgressView("Loading full Sessionize schedule...")
                                .frame(maxWidth: .infinity)
                                .padding(32)
                        } else if let errorMessage, sessions.isEmpty {
                            ContentUnavailableView("Schedule unavailable", systemImage: "wifi.exclamationmark", description: Text(errorMessage))
                                .padding(.top, 40)
                        }
                        ForEach(filteredSessions) { session in
                            NavigationLink(value: session) {
                                SessionCard(session: session, isFavorite: favoriteSessionIDs.contains(session.id), toggleFavorite: { toggleFavorite(session) })
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(18)
            }
        }
        .searchable(text: $searchText, prompt: "Search sessions or speakers")
        .navigationDestination(for: Session.self) { session in
            SessionDetailView(session: session, isFavorite: favoriteSessionIDs.contains(session.id), toggleFavorite: { toggleFavorite(session) })
        }
    }
}

private struct HeroHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cloud Native Zurich")
                .font(.system(.largeTitle, design: .rounded, weight: .black))
                .foregroundStyle(Theme.ink)
            Text("\(ConferenceData.eventDate) · \(ConferenceData.venue)")
                .font(.headline)
                .foregroundStyle(Theme.sea)
            Text("Four tracks, every scheduled talk, and the full Sessionize speaker details for the Cloud Native Zurich conference day.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.white.opacity(0.82))
                .shadow(color: Theme.ink.opacity(0.08), radius: 18, y: 8)
        }
    }
}

private struct TrackPicker: View {
    @Binding var selectedTrack: Track?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                TrackChip(title: "All", subtitle: "Tracks", isSelected: selectedTrack == nil) { selectedTrack = nil }
                ForEach(Track.allCases) { track in
                    TrackChip(title: track.rawValue, subtitle: track.room, isSelected: selectedTrack == track) { selectedTrack = track }
                }
            }
            .padding(.vertical, 2)
        }
    }
}

private struct TrackChip: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.weight(.bold))
                Text(subtitle).font(.caption.weight(.medium))
            }
            .foregroundStyle(isSelected ? .white : Theme.ink)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? Theme.ink : .white.opacity(0.75), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}
