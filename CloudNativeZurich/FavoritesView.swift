import SwiftUI

struct FavoritesView: View {
    let favoriteSessionIDs: Set<UUID>
    let toggleFavorite: (Session) -> Void

    private var favorites: [Session] {
        ConferenceData.sessions.filter { favoriteSessionIDs.contains($0.id) }
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            if favorites.isEmpty {
                ContentUnavailableView("No favorites yet", systemImage: "star", description: Text("Save sessions from the schedule to build your day."))
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(favorites) { session in
                            NavigationLink(value: session) {
                                SessionCard(session: session, isFavorite: true, toggleFavorite: { toggleFavorite(session) })
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(18)
                }
            }
        }
        .navigationDestination(for: Session.self) { session in
            SessionDetailView(session: session, isFavorite: favoriteSessionIDs.contains(session.id), toggleFavorite: { toggleFavorite(session) })
        }
    }
}
