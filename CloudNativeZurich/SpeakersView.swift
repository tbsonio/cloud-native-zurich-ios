import SwiftUI

struct SpeakersView: View {
    let speakers: [Speaker]
    let isLoading: Bool
    @State private var searchText = ""

    private var filteredSpeakers: [Speaker] {
        if searchText.isEmpty {
            return speakers
        } else {
            return speakers.filter { speaker in
                speaker.name.localizedCaseInsensitiveContains(searchText) ||
                speaker.tagline.localizedCaseInsensitiveContains(searchText) ||
                speaker.bio.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        Group {
            if isLoading && speakers.isEmpty {
                ProgressView("Loading speakers...")
            } else {
                List(filteredSpeakers) { speaker in
                    SpeakerRow(speaker: speaker)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .background(Theme.background)
        .searchable(text: $searchText, prompt: "Search speakers")
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
