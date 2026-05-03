# archiving Specification

## Purpose
To provide a centralized system for managing archived items, allowing users to hide, restore, or permanently delete counters and date events.

## Requirements

### Requirement: Centralized Archive Management
The system SHALL provide a dedicated view to manage all archived counters and date events.

#### Scenario: View Archived Items
- **WHEN** a user navigates to the "Archived Items" section in Settings
- **THEN** they SHALL see a list of all items marked as archived
- **AND** the list SHALL distinguish between Counters and Date Events.

### Requirement: Restore Archived Items
The system SHALL allow users to restore archived items back to their respective active lists.

#### Scenario: Unarchive a Counter
- **GIVEN** a counter is currently in the archived list
- **WHEN** the user selects the "Unarchive" action for that counter
- **THEN** the counter SHALL be removed from the archived list
- **AND** it SHALL reappear in the main "Counters" list.

### Requirement: Permanent Deletion from Archive
The system SHALL allow users to permanently delete items that are in the archived list.

#### Scenario: Delete an Archived Event
- **GIVEN** a date event is currently in the archived list
- **WHEN** the user selects the "Delete" action and confirms
- **THEN** the date event SHALL be permanently removed from the system.
