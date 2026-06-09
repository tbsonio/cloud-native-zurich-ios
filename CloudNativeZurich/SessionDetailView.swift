import SwiftUI

struct SessionDetailView: View {
    let session: Session
    let isFavorite: Bool
    let toggleFavorite: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(session.timeRange)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Theme.sea)
                    Text(session.title)
                        .font(.system(.title, design: .rounded, weight: .black))
                        .foregroundStyle(Theme.ink)
                    Text("\(session.track.rawValue) · \(session.room) · \(session.durationMinutes) min")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Button(action: toggleFavorite) {
                    Label(isFavorite ? "Saved to Favorites" : "Save Session", systemImage: isFavorite ? "star.fill" : "star")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.ink)

                Text(session.summary)
                    .font(.body)
                    .foregroundStyle(Theme.ink.opacity(0.78))

                if !session.categories.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Session Info")
                            .font(.title3.weight(.bold))
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], alignment: .leading, spacing: 8) {
                            ForEach(session.categories, id: \.self) { category in
                                Text(category)
                                    .font(.caption.weight(.bold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Theme.moss.opacity(0.16), in: Capsule())
                            }
                        }
                    }
                }

                if !session.speakers.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Speakers")
                            .font(.title3.weight(.bold))
                        ForEach(session.speakers) { speaker in
                            VStack(alignment: .leading, spacing: 8) {
                                SpeakerRow(speaker: speaker)
                                if !speaker.bio.isEmpty {
                                    Text(speaker.bio)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                ForEach(speaker.links, id: \.self) { link in
                                    if let url = link.url {
                                        Link(destination: url) {
                                            Label(link.title, systemImage: "link")
                                                .font(.footnote.weight(.semibold))
                                        }
                                    }
                                }
                            }
                            .padding(12)
                            .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                    }
                }

                if let liveURL = session.liveURL {
                    Link(destination: liveURL) {
                        Label("Live stream", systemImage: "play.rectangle")
                    }
                }

                if let recordingURL = session.recordingURL {
                    Link(destination: recordingURL) {
                        Label("Recording", systemImage: "video")
                    }
                }
            }
            .padding(18)
        }
        .background(Theme.background)
    }
}
