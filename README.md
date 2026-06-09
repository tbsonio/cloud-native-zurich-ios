# Cloud Native Zurich iOS

A SwiftUI iOS schedule app inspired by the Cloud Native Zurich 2026 Sessionize app and the conference schedule page.

## Features

- Schedule browsing for the 11 June 2026 conference day
- Track filters for Main Track 1, Main Track 2, Sovereignty, and Sponsor sessions
- Search across sessions and speakers
- Session detail pages with speaker imagery from Sessionize
- Local favorites stored on-device
- Event links for the Sessionize app and Cloud Native Zurich schedule

## Development

This project uses XcodeGen so the Xcode project can be recreated deterministically.

```bash
brew install xcodegen
xcodegen generate
open CloudNativeZurich.xcodeproj
```

Build from the command line:

```bash
xcodebuild -scheme CloudNativeZurich -destination 'generic/platform=iOS Simulator' build
```

## Apple Docs MCP

The VS Code MCP configuration is in `.vscode/mcp.json` and registers the requested `apple-docs` server:

```json
{
  "servers": {
    "apple-docs": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@kimsungwhee/apple-docs-mcp"]
    }
  }
}
```

## Local Mac CI/CD

The GitHub Actions workflow in `.github/workflows/ios-ci.yml` is configured for a self-hosted macOS runner. Once this repository exists on GitHub, register this Mac as the runner:

```bash
scripts/install-github-runner.sh tbsonio cloud-native-zurich-ios
```

After the runner service is installed, every push to `main` will build the app on this Mac.
