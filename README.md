# Cloud Native Zurich iOS

A SwiftUI iOS schedule app inspired by the Cloud Native Zurich 2026 Sessionize app and the conference schedule page.

## Color Palette

The app uses a carefully designed color palette:

| Color | Hex | Usage |
|-------|-----|-------|
| Dark navy | `#0A1133` | Main text, headings, borders, icons |
| White | `#FFFFFF` | Page and navigation backgrounds |
| Very light cyan | `#EFFAFB` | Schedule cards and panels |
| Light blue-gray | `#DFEFF2` | Buttons and hover backgrounds |
| Selected blue-gray | `#D4E8EC` | Selected track tab |
| Turquoise | `#06B3B8` | Links, hover states, active-session borders |
| Bright blue | `#3333FF` | Links and blue accents |
| Orange-red | `#F14600` | Highlight text, bullets and accents |
| Pale orange | `#FFF4F0` | Orange-tinted backgrounds |
| Peach | `#FCC5B1` | Decorative accents |
| Medium gray | `#808080` | Loading and secondary text |

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

The GitHub Actions workflow in `.github/workflows/ios-ci.yml` is configured for a self-hosted macOS runner. For this project, the runner is the hosted Mac provided by Flow Swiss. GitHub still coordinates the workflow, but the actual build runs on the Flow Swiss Mac, so Xcode, the iOS Simulator SDK, Homebrew, and signing/build caches stay local to that machine.

How it works:

- A push to `main`, a pull request, or a manual `workflow_dispatch` starts the `iOS CI` workflow in GitHub Actions.
- The workflow asks GitHub for a runner matching `self-hosted` and `macOS`.
- The Flow Swiss hosted Mac runs the GitHub Actions runner service and advertises the labels `self-hosted`, `macOS`, `ios`, and `xcode`.
- GitHub sends the job to that Mac. The runner checks out the repository, installs XcodeGen if needed, regenerates `CloudNativeZurich.xcodeproj`, and runs the simulator build.
- Because the runner is installed as a macOS service, it starts automatically after the machine reboots and keeps listening for new jobs.

The runner can be installed or reinstalled with:

```bash
scripts/install-github-runner.sh tbsonio cloud-native-zurich-ios
```

The script uses the authenticated GitHub CLI session to request a short-lived repository runner registration token, downloads the official macOS arm64 GitHub Actions runner, configures it under `~/actions-runner-cloud-native-zurich-ios`, and starts it via `svc.sh`.

Useful checks on the Flow Swiss Mac:

```bash
gh run list --repo tbsonio/cloud-native-zurich-ios --workflow "iOS CI" --limit 5
ps aux | grep '[R]unner.Listener'
~/actions-runner-cloud-native-zurich-ios/svc.sh status
```

After the runner service is installed, every push to `main` builds the app on the hosted Mac automatically.
