import SwiftUI

struct InfoView: View {
    var body: some View {
        List {
            Section("Event") {
                LabeledContent("Date", value: ConferenceData.eventDate)
                LabeledContent("Venue", value: ConferenceData.venue)
                LabeledContent("Tracks", value: "4")
                LabeledContent("Schedule Source", value: "Sessionize API")
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
