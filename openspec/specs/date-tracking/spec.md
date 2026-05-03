# date-tracking Specification

## Purpose
TBD - created by archiving change add-date-tracking.

## Requirements

### Requirement: User can add a date event
The system SHALL allow a user to create a new date event by providing a name, a specific date, and an archived state.

#### Scenario: Successful addition of a future event
- **WHEN** a user enters a name "Birthday", selects a date in the future, and saves
- **THEN** the "Birthday" event SHALL appear in the list of date events
- **AND** the archived state SHALL be `false` by default.

### Requirement: User can view a list of date events
The system SHALL display all active (non-archived) saved date events in a chronological list.

#### Scenario: Displaying only active events
- **GIVEN** there is an active event "Vacation"
- **AND** there is an archived event "Old Conference"
- **WHEN** the user navigates to the date tracking screen
- **THEN** "Vacation" SHALL be visible in the list
- **AND** "Old Conference" SHALL NOT be visible.

### Requirement: User can delete a date event
The system SHALL allow a user to remove a date event from their list.

#### Scenario: Successful deletion
- **GIVEN** a "Doctor's Appointment" event exists
- **WHEN** the user performs the delete action on that event and confirms
- **THEN** the "Doctor's Appointment" event SHALL be removed from the list.

### Requirement: System calculates time difference
The system SHALL calculate and display the relative time from the current date to a given event date.

#### Scenario: Date in the future
- **GIVEN** an event is scheduled for 7 days from today
- **WHEN** the event is displayed
- **THEN** the system SHALL display a label similar to "in 7 days".

#### Scenario: Date in the past
- **GIVEN** an event occurred 3 days ago
- **WHEN** the event is displayed
- **THEN** the system SHALL display a label similar to "3 days ago".

#### Scenario: Date is today
- **GIVEN** an event is scheduled for today
- **WHEN** the event is displayed
- **THEN** the system SHALL display a label similar to "Today".

### Requirement: Archiving a Date Event
The system SHALL allow a user to archive a date event to remove it from the active list.

#### Scenario: Successful archiving
- **GIVEN** an active "Project Launch" event exists
- **WHEN** the user performs the "Archive" action on that event
- **THEN** the "Project Launch" event SHALL be marked as archived
- **AND** it SHALL be removed from the active list.
