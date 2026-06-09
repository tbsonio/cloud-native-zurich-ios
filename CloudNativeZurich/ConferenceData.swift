import Foundation

enum ConferenceData {
    static let eventDate = "11 June, 2026"
    static let venue = "Abaton, Zurich"
    static let sessionizeURL = URL(string: "https://cloud-native-zurich-2026.sessionize.com/")!
    static let websiteURL = URL(string: "https://cloudnativezurich.ch/schedule/")!

    static let sessions: [Session] = [
        session("Registration & Coffee", at: "08:00", duration: 45, track: .mainTrack1, summary: "Badge pickup and first coffee before the opening program."),
        session("Welcoming and Opening Session", at: "08:45", duration: 15, track: .mainTrack1, summary: "Kickoff for Cloud Native Zurich 2026."),
        session("State of the GenAI Supply Chain: Slopsquatting and Secure OSS Demystified", at: "09:00", duration: 30, track: .mainTrack1, speaker: speaker("Andrew Martin", image: "https://sessionize.com/image/f662-400o400o1-VskPXPvZjWbhp1W5rz7ZE6.jpg"), difficulties: [.beginner], summary: "A security-focused look at GenAI supply-chain risk and open-source dependency hygiene."),
        session("From Selecta vending machines to Menu-as-a-Service: Engineering the Golden Path", at: "09:45", duration: 30, track: .mainTrack1, speakers: [speaker("Christoph Raaflaub", image: "https://sessionize.com/image/56c0-400o400o1-Jzssvxa2dRmVixmYsE9zpV.jpg"), speaker("Dominik Bartholdi", image: "https://sessionize.com/image/5f8f-400o400o1-RaXRFRYjSi135XGLQ2mi6A.png")], summary: "A platform engineering story about turning product delivery into a paved road."),
        session("Coffee Break", at: "10:15", duration: 30, track: .mainTrack1, difficulties: [.beginner], summary: "Break time across the venue."),
        session("Vibe Code Suvival Guide for Open-Source", at: "10:45", duration: 30, track: .mainTrack1, speaker: speaker("Vadim Bauer", image: "https://sessionize.com/image/94dc-400o400o1-pzAfSRvvhBo4GrQwokjuPJ.jpeg"), difficulties: [.beginner], summary: "Practical guidance for using AI-assisted coding in open-source communities."),
        session("Scaling ALPS: From HPC to Apertus", at: "11:30", duration: 30, track: .mainTrack1, speaker: speaker("Nina Mujkanovic", image: "https://sessionize.com/image/7bf6-400o400o1-LbxSYLG1UinMwLrgxMMAyd.jpg"), difficulties: [.beginner], summary: "How Swiss high-performance computing ideas scale into modern platforms."),
        session("Lunch", at: "12:00", duration: 90, track: .mainTrack1, summary: "Lunch break from 12:00 to 13:30."),
        session("AI Won't Replace Your Platform Team (But It Will Change Their Job)", at: "12:45", duration: 30, track: .mainTrack1, speaker: speaker("Tobias Vonesch", image: "https://sessionize.com/image/ed74-400o400o1-S7DFXDvK7D16LZniEQb4J1.jpg"), difficulties: [.beginner, .sponsorTalk], summary: "A sponsor-track view of how AI changes platform team workflows."),
        session("All for one, and one for all! Find more and store less by combining eBPF security tools", at: "13:30", duration: 30, track: .mainTrack1, speaker: speaker("Constanze Roedig", image: "https://sessionize.com/image/253f-400o400o1-VpAoguszudpUUvL4YpyhcC.png"), difficulties: [.intermediate], summary: "Combining eBPF security tooling for better runtime visibility."),
        session("Beyond API Keys: Fine-Grained AI Agent Authorization for DevOps with OpenFGA", at: "14:15", duration: 30, track: .mainTrack1, speaker: speaker("Tom Graupner", image: "https://sessionize.com/image/7a13-400o400o1-R6rwTwvsuzGsUh9zCqcTfU.jpg"), difficulties: [.intermediate], summary: "Authorization patterns for AI agents in DevOps environments."),
        session("Coffee Break", at: "14:45", duration: 30, track: .mainTrack1, difficulties: [.beginner], summary: "Afternoon break across the venue."),
        session("Operating the Orbital Edge: in space no-one can hear you ping", at: "15:15", duration: 30, track: .mainTrack1, speaker: speaker("Declan Doherty", image: "https://sessionize.com/image/f7ed-400o400o1-hctQnmm26wMC5EJRVJPQpK.jpg"), difficulties: [.beginner], summary: "Running edge systems in space-like operational constraints."),
        session("MarmotGraph: Building knowledge graphs for neuroscience, supercomputer centers and more", at: "16:00", duration: 45, track: .mainTrack1, speaker: speaker("Oliver Schmid", image: "https://sessionize.com/image/5112-400o400o1-MwPztWtKiiQciiUZy5JnY8.jpg"), difficulties: [.beginner], summary: "Knowledge graph patterns for research and infrastructure domains."),
        session("Bringing Big Data into Space: The Roman Space Telescope and new Earth Observing Systems", at: "16:45", duration: 45, track: .mainTrack1, speaker: speaker("Thomas Zurbuchen", image: "https://sessionize.com/image/134b-400o400o1-UpgJbHEKzS4Ct1yX3h9aWQ.jpg"), summary: "A keynote-style session on space systems and earth-observation data."),
        session("Networking Apero", at: "17:30", duration: 215, track: .mainTrack1, summary: "Closing networking program."),
        session("Parallel cloud native sessions", at: "09:00", duration: 405, track: .mainTrack2, difficulties: [.beginner, .intermediate], summary: "Additional talks from the published four-track conference program."),
        session("Sovereignty track sessions", at: "09:00", duration: 405, track: .sovereignty, difficulties: [.beginner, .intermediate], summary: "Sessions focused on digital sovereignty and cloud native practice."),
        session("Sponsor track sessions", at: "09:00", duration: 405, track: .sponsor, difficulties: [.sponsorTalk], summary: "Sponsor talks and partner content in ABATON 3."),
    ]

    static var speakers: [Speaker] {
        let allSpeakers = sessions.flatMap(\.speakers)
        return Array(Set(allSpeakers)).sorted { $0.name < $1.name }
    }

    private static func session(_ title: String, at time: String, duration: Int, track: Track, speaker: Speaker? = nil, speakers: [Speaker] = [], difficulties: [Difficulty] = [], summary: String) -> Session {
        Session(id: UUID(), title: title, start: components(for: time), durationMinutes: duration, track: track, speakers: speaker.map { [$0] } ?? speakers, difficulties: difficulties, summary: summary)
    }

    private static func speaker(_ name: String, image: String) -> Speaker {
        Speaker(id: UUID(), name: name, imageURL: URL(string: image))
    }

    private static func components(for time: String) -> DateComponents {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        return DateComponents(calendar: Calendar(identifier: .gregorian), year: 2026, month: 6, day: 11, hour: parts.first, minute: parts.dropFirst().first)
    }
}
