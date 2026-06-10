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
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28, height: 28)
                                .clipShape(Circle())
                        }
                    }
            }
            .tabItem { Label("Schedule", systemImage: "calendar") }

            NavigationStack {
                FavoritesView(sessions: store.sessions, favoriteSessionIDs: favoriteSessionIDs, toggleFavorite: toggleFavorite)
                    .navigationTitle("Favorites")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28, height: 28)
                                .clipShape(Circle())
                        }
                    }
            }
            .tabItem { Label("Favorites", systemImage: "star") }

            NavigationStack {
                SpeakersView(speakers: store.speakers, isLoading: store.isLoading)
                    .navigationTitle("Speakers")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28, height: 28)
                                .clipShape(Circle())
                        }
                    }
            }
            .tabItem { Label("Speakers", systemImage: "person.2") }

            NavigationStack {
                InfoView()
                    .navigationTitle("Info")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28, height: 28)
                                .clipShape(Circle())
                        }
                    }
            }
            .tabItem { Label("Info", systemImage: "info.circle") }
        }
        .tint(Theme.ink)
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
