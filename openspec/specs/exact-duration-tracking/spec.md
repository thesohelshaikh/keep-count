# exact-duration-tracking Specification

## Purpose
Provides functionality to calculate and display precise time durations between events and the current time.

## Requirements
### Requirement: Precise Duration Calculation
The system SHALL provide a way to calculate the precise duration between a given date (e.g., the last event timestamp) and the current time, expressed in multiple units (years, months, weeks, days, hours, minutes, seconds) as appropriate.

#### Scenario: Calculating duration for a recent event
- **WHEN** the last event was 1 hour and 30 minutes ago
- **THEN** the system SHALL calculate the duration as "1 hour, 30 minutes"

#### Scenario: Calculating duration for an older event
- **WHEN** the last event was 2 weeks and 3 days ago
- **THEN** the system SHALL calculate the duration as "2 weeks, 3 days"

### Requirement: Precise Duration Display
The system SHALL format the precise duration into a human-readable string for display in the UI.

#### Scenario: Formatting duration string
- **WHEN** the duration is 1 day, 4 hours, and 12 minutes
- **THEN** the system SHALL produce the string "1 day, 4 hours, 12 minutes ago"
