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
                    Text("\(session.track.rawValue) · \(session.track.room)")
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

                if !session.speakers.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Speakers")
                            .font(.title3.weight(.bold))
                        ForEach(session.speakers) { speaker in
                            SpeakerRow(speaker: speaker)
                        }
                    }
                }
            }
            .padding(18)
        }
        .background(Theme.background)
    }
}
