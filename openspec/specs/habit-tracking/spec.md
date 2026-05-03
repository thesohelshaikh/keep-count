# habit-tracking Specification

## Purpose
TBD - created by archiving change initial-app-spec. Update Purpose after archive.
## Requirements
### Requirement: Habit Type
The system SHALL allow counters to be marked as "Positive" or "Negative" habits.

#### Scenario: Setting habit type
- **WHEN** editing a counter
- **THEN** a user SHALL be able to toggle between positive and negative habit types

### Requirement: Habit Progress Visualization
The system SHALL visualize progress differently based on habit type and goals.

#### Scenario: Positive habit progress
- **WHEN** a positive habit counter's value increases towards its goal
- **THEN** the progress bar SHALL fill with a success color (e.g., green)

