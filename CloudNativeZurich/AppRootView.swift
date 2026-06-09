import SwiftUI

struct AppRootView: View {
    @AppStorage("favoriteSessionIDs") private var favoriteSessionIDsData = Data()
    @State private var selectedTrack: Track? = nil
    @State private var searchText = ""

    private var favoriteSessionIDs: Set<UUID> {
        get { (try? JSONDecoder().decode(Set<UUID>.self, from: favoriteSessionIDsData)) ?? [] }
        nonmutating set { favoriteSessionIDsData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    var body: some View {
        TabView {
            NavigationStack {
                ScheduleView(selectedTrack: $selectedTrack, searchText: $searchText, favoriteSessionIDs: favoriteSessionIDs, toggleFavorite: toggleFavorite)
                    .navigationTitle("Schedule")
            }
            .tabItem { Label("Schedule", systemImage: "calendar") }

            NavigationStack {
                FavoritesView(favoriteSessionIDs: favoriteSessionIDs, toggleFavorite: toggleFavorite)
                    .navigationTitle("Favorites")
            }
            .tabItem { Label("Favorites", systemImage: "star") }

            NavigationStack {
                SpeakersView()
                    .navigationTitle("Speakers")
            }
            .tabItem { Label("Speakers", systemImage: "person.2") }

            NavigationStack {
                InfoView()
                    .navigationTitle("Info")
            }
            .tabItem { Label("Info", systemImage: "info.circle") }
        }
        .tint(Theme.ink)
    }

    private func toggleFavorite(_ session: Session) {
        var next = favoriteSessionIDs
        if next.contains(session.id) {
            next.remove(session.id)
        } else {
            next.insert(session.id)
        }
        favoriteSessionIDs = next
    }
}
