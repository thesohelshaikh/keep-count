# KeepCount

KeepCount is a modern, privacy-focused iOS application designed to track occurrences, habits, and progress. Inspired by [BetterCounter](https://github.com/albertvaka/bettercounter), it emphasizes not just the count, but the chronological history of every event.

## Features

- **Event Tracking**: Every increment, decrement, and reset is automatically recorded with a timestamp.
- **History Management**: View a detailed log of all activity, add manual entries in the past, or delete specific events with confirmation.
- **Habit Monitoring**: Categorize counters as "Positive" or "Negative" to visualize progress against goals with habit-aware progress bars.
- **Smart Categories**: Organize counters into categories that are created inline and automatically cleaned up when empty.
- **Data Portability**: Export your entire counter history as a CSV file via the native iOS Share Sheet.
- **Modern UI**: Full support for Dark Mode, native Search, and high-resolution scaling for all modern iOS devices (including iPhone 15 Plus).
- **Privacy First**: All data is stored locally on your device using SwiftData.

## Architecture

The project follows modern iOS development standards:
- **Language**: Swift 5.10+
- **UI Framework**: SwiftUI
- **Persistence**: SwiftData
- **Project Management**: [XcodeGen](https://github.com/yonaskolb/XcodeGen) (configured via `project.yml`)
- **Specification**: [OpenSpec](https://github.com/Fission-AI/OpenSpec) (located in `openspec/`)

## Getting Started

### Prerequisites
- macOS with Xcode 15.0+ installed.
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`).

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/thesohelshaikh/keep-count.git
   cd keep-count
   ```
2. Generate the Xcode project:
   ```bash
   xcodegen generate
   ```
3. Open `KeepCount.xcodeproj` and run the app on your simulator or device.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
