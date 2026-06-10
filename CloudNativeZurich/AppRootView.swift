import SwiftUI

struct AppRootView: View {
    @StateObject private var store = SessionStore()
    @AppStorage("favoriteSessionIDs") private var favoriteSessionIDsData = Data()
    @State private var selectedTrack: Track? = nil
    @State private var searchText = ""

    private var favoriteSessionIDs: Set<String> {
        get { (try? JSONDecoder().decode(Set<String>.self, from: favoriteSessionIDsData)) ?? [] }
        nonmutating set { favoriteSessionIDsData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    var body: some View {
        TabView {
            NavigationStack {
                ScheduleView(
                    sessions: store.sessions,
                    isLoading: store.isLoading,
                    errorMessage: store.errorMessage,
                    selectedTrack: $selectedTrack,
                    searchText: $searchText,
                    favoriteSessionIDs: favoriteSessionIDs,
                    toggleFavorite: toggleFavorite
                )
                    .navigationTitle("Schedule")
            }
            .tabItem { Label("Schedule", systemImage: "calendar") }

            NavigationStack {
                FavoritesView(sessions: store.sessions, favoriteSessionIDs: favoriteSessionIDs, toggleFavorite: toggleFavorite)
                    .navigationTitle("Favorites")
            }
            .tabItem { Label("Favorites", systemImage: "star") }

            NavigationStack {
                SpeakersView(speakers: store.speakers, isLoading: store.isLoading)
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let logo = UIImage(named: "logo") {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                }
            }
        }
        .task { await store.load() }
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
