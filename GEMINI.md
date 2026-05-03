# Project Instructions: KeepCount

These instructions guide AI interactions and development standards for the KeepCount project.

## Architecture & Frameworks
- **SwiftUI**: Use modern SwiftUI (iOS 17+) components like `NavigationStack` and `ContentUnavailableView`.
- **SwiftData**: All persistence must use `@Model` and `@Query`. Ensure relationships are synchronized on both sides during saving.
- **XcodeGen**: Never commit the `.xcodeproj` file. Always update `project.yml` when adding new files or changing build settings.
- **Human Interface Guidelines (HIG)**: Adhere strictly to Apple's design principles. Use `.confirmationDialog` for destructive actions and monospaced digits for data values.

## File Organization
- `KeepCount/App/`: Main entry point.
- `KeepCount/UI/Models/`: Data models (entities).
- `KeepCount/UI/Views/`: SwiftUI views.
- `KeepCount/Resources/`: Asset catalogs and localizable strings.

## Specialized Workflows
- **OpenSpec**: Use the Spec-Driven Development framework for all feature additions. Active changes live in `openspec/changes/` and archived specs in `openspec/specs/`.
- **Relationship Management**: When adding a counter to a category, manually update both the counter's property and the category's array to ensure immediate UI reactivity.

## Testing & Verification
- Before finishing any task, run:
  ```bash
  xcodegen generate && xcodebuild -project KeepCount.xcodeproj -scheme KeepCount -sdk iphonesimulator build
  ```
