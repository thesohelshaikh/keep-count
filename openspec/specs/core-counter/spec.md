# core-counter Specification

## Purpose
TBD - created by archiving change initial-app-spec. Update Purpose after archive.
## Requirements
### Requirement: Counter Model
The system SHALL maintain a Counter model with name, value, initial value, step, goal, color, category, an archived state, and a creation date.

#### Scenario: Counter Initialization
- **WHEN** a user creates a new counter
- **THEN** it SHALL be initialized with the provided values or defaults
- **AND** the archived state SHALL be `false` by default
- **AND** the creation date SHALL be set to the current timestamp by default.

### Requirement: Category Model
The system SHALL maintain a Category model that can contain multiple counters and has a user-definable order.

#### Scenario: Category Creation
- **WHEN** a user creates a new category
- **THEN** it SHALL be able to hold a list of counters.

#### Scenario: Category Display Order
- **WHEN** categories are displayed to the user
- **THEN** they SHALL be displayed in the user-defined order.

### Requirement: Increment and Decrement
The system SHALL allow users to increment and decrement counter values by a specified step.

#### Scenario: Successful Increment
- **WHEN** a user taps the increment button
- **THEN** the counter value SHALL increase by the step amount
- **AND** haptic feedback SHALL be provided

### Requirement: Counter Reset
The system SHALL allow users to reset a counter to its initial value.

#### Scenario: Reset Counter
- **WHEN** a user taps the reset button
- **THEN** the counter value SHALL return to its initial value

### Requirement: Archiving a Counter
The system SHALL allow users to archive a counter to remove it from the active list.

#### Scenario: Successful Archiving
- **GIVEN** an active counter exists in the main list
- **WHEN** the user performs the "Archive" swipe action
- **THEN** the counter SHALL be marked as archived
- **AND** it SHALL no longer be visible in the main "Counters" list.

### Requirement: Display Counter Creation Date
The system SHALL display the date the counter was created within the counter details view.

#### Scenario: Viewing Counter Details
- **GIVEN** a counter was created on "2026-05-01"
- **WHEN** the user views the history details for that counter
- **THEN** they SHALL see a "Created on" label with the date "May 1, 2026".

