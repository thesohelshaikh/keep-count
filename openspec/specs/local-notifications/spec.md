# local-notifications Specification

## Purpose
Infrastructure for managing system-level alerts and reminders, specifically for date events.

## Requirements

### Requirement: Local Notification Permission Request
The system SHALL request permission from the user to send local notifications.

#### Scenario: Requesting permission
- **WHEN** the user enables the notification toggle for the first time
- **THEN** the system SHALL prompt for notification permissions using standard iOS dialogs

### Requirement: Schedule Event Reminder
The system SHALL schedule a local notification for enabled events on the day of the event.

#### Scenario: Scheduling a notification
- **WHEN** an event is saved with "Notify me on the day" enabled
- **THEN** a local notification SHALL be scheduled for the event's date (defaulting to 9:00 AM)

### Requirement: Cancel Event Reminder
The system SHALL cancel scheduled local notifications when an event is deleted or the notification toggle is disabled.

#### Scenario: Canceling a notification
- **WHEN** an event with an active notification is deleted
- **OR** the user disables the notification toggle for that event
- **THEN** the corresponding scheduled notification SHALL be removed from the system
