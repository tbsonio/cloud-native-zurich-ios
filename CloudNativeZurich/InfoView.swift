import SwiftUI

struct InfoView: View {
    var body: some View {
        List {
            Section("Event") {
                LabeledContent("Date", value: ConferenceData.eventDate)
                LabeledContent("Venue", value: ConferenceData.venue)
                LabeledContent("Tracks", value: "4")
            }
            Section("Links") {
                Link(destination: ConferenceData.sessionizeURL) {
                    Label("Sessionize App", systemImage: "calendar.badge.clock")
                }
                Link(destination: ConferenceData.websiteURL) {
                    Label("Conference Schedule", systemImage: "safari")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Theme.background)
    }
}
