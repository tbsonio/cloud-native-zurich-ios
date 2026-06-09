import SwiftUI

struct SpeakersView: View {
    var body: some View {
        List(ConferenceData.speakers) { speaker in
            SpeakerRow(speaker: speaker)
        }
        .scrollContentBackground(.hidden)
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

            Text(speaker.name)
                .font(.headline)
                .foregroundStyle(Theme.ink)
        }
        .padding(.vertical, 6)
    }
}
