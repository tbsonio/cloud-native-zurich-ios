import SwiftUI

struct SessionCard: View {
    let session: Session
    let isFavorite: Bool
    let toggleFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.timeRange)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.sea)
                    Text(session.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 12)
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(isFavorite ? Theme.sun : Theme.ink.opacity(0.45))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isFavorite ? "Remove favorite" : "Add favorite")
            }

            if !session.speakers.isEmpty {
                Text(session.speakerLine)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                Label(session.room, systemImage: "mappin.and.ellipse")
                    .font(.caption.weight(.semibold))
                ForEach(session.categories.prefix(2), id: \.self) { category in
                    Text(category)
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.moss.opacity(0.16), in: Capsule())
                }
            }
            .foregroundStyle(Theme.ink.opacity(0.72))
        }
        .padding(16)
        .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
