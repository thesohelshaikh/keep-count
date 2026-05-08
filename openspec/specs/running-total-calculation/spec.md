# running-total-calculation Specification

## Purpose
Logic to compute the state of a counter at any historical point.

## Requirements
### Requirement: Running Total Calculation Consistency
The calculation of running totals SHALL always start from the counter's `initialValue` and proceed chronologically through all recorded history events.

#### Scenario: Consistent calculation
- **WHEN** history events are added or deleted
- **THEN** the displayed running totals for all remaining events SHALL be recalculated to remain accurate relative to the `initialValue`.
