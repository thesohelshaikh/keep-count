# core-counter Specification

## Purpose
TBD - created by archiving change initial-app-spec. Update Purpose after archive.
## Requirements
### Requirement: Counter Model
The system SHALL maintain a Counter model with name, value, initial value, step, goal, color, and category.

#### Scenario: Counter Initialization
- **WHEN** a user creates a new counter
- **THEN** it SHALL be initialized with the provided values or defaults

### Requirement: Category Model
The system SHALL maintain a Category model that can contain multiple counters.

#### Scenario: Category Creation
- **WHEN** a user creates a new category
- **THEN** it SHALL be able to hold a list of counters

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

