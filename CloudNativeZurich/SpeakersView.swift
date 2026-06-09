import SwiftUI

struct SpeakersView: View {
    let speakers: [Speaker]
    let isLoading: Bool

    var body: some View {
        Group {
            if isLoading && speakers.isEmpty {
                ProgressView("Loading speakers...")
            } else {
                List(speakers) { speaker in
                    SpeakerRow(speaker: speaker)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .background(Theme.background)
    }
}

struct SpeakerRow: View {
    let speaker: Speaker

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: speaker.imageURL) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill()
                case .failure: Image(systemName: "person.crop.circle.fill").resizable().foregroundStyle(Theme.sea)
                case .empty: ProgressView()
                @unknown default: EmptyView()
                }
            }
            .frame(width: 52, height: 52)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(speaker.name)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                if !speaker.tagline.isEmpty {
                    Text(speaker.tagline)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 6)
    }
}
