import SwiftUI

enum Theme {
    // New color palette
    static let darkNavy = Color(red: 10/255, green: 17/255, blue: 51/255)        // #0A1133 - Main text, headings, borders, icons
    static let white = Color.white                                               // #FFFFFF - Page and navigation backgrounds
    static let veryLightCyan = Color(red: 239/255, green: 250/255, blue: 251/255) // #EFFAFB - Schedule cards and panels
    static let lightBlueGray = Color(red: 223/255, green: 239/255, blue: 242/255) // #DFEFF2 - Buttons and hover backgrounds
    static let selectedBlueGray = Color(red: 212/255, green: 232/255, blue: 236/255) // #D4E8EC - Selected track tab
    static let turquoise = Color(red: 6/255, green: 179/255, blue: 184/255)      // #06B3B8 - Links, hover states, active-session borders
    static let brightBlue = Color(red: 51/255, green: 51/255, blue: 255/255)     // #3333FF - Links and blue accents
    static let orangeRed = Color(red: 241/255, green: 70/255, blue: 0)           // #F14600 - Highlight text, bullets and accents
    static let paleOrange = Color(red: 255/255, green: 244/255, blue: 240/255)   // #FFF4F0 - Orange-tinted backgrounds
    static let peach = Color(red: 252/255, green: 197/255, blue: 177/255)        // #FCC5B1 - Decorative accents
    static let mediumGray = Color(red: 128/255, green: 128/255, blue: 128/255)   // #808080 - Loading and secondary text

    // Semantic color mappings for app components (maintaining existing API)
    static let ink = darkNavy           // Main text
    static let sea = turquoise          // Links and interactive elements
    static let moss = brightBlue        // Accent color
    static let paper = white            // Backgrounds
    static let sun = orangeRed          // Highlights and accents

    // Updated background gradient using new colors
    static let background = LinearGradient(
        colors: [veryLightCyan, Color(red: 215/255, green: 237/255, blue: 240/255)], 
        startPoint: .topLeading, 
        endPoint: .bottomTrailing
    )
}
