# counter-history Specification

## Purpose
TBD - created by archiving change initial-app-spec. Update Purpose after archive.
## Requirements
### Requirement: History Event Recording
The system SHALL record every increment and decrement event with a timestamp.

#### Scenario: Recording an increment
- **WHEN** a user increments a counter
- **THEN** a new history event SHALL be created with the current timestamp and the change amount

### Requirement: History View
The system SHALL provide a view to see the chronological history of events for a specific counter.

#### Scenario: Viewing history
- **WHEN** a user opens the details for a counter
- **THEN** they SHALL see a list of all past increment/decrement events with their times

### Requirement: Show Exact Duration in Details
The system SHALL display the exact duration since the last history event in the counter's detail view.

#### Scenario: Displaying duration in sheet
- **WHEN** a user opens the `HistoryDetailView` for a counter
- **THEN** they SHALL see a "Last Activity" or "Duration" field showing the precise time since the most recent event.

### Requirement: Display Running Total in History
The system SHALL display the cumulative total of the counter as it was immediately after each history event.

#### Scenario: Viewing history with totals
- **WHEN** a user views the history of a counter with an initial value of 0
- **AND** there is an event "+5" followed by "-2"
- **THEN** the first event SHALL show a total of "5"
- **AND** the second event SHALL show a total of "3"

