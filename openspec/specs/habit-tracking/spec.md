# habit-tracking Specification

## Purpose
DEPRECATED: Habit tracking features (positive/negative types) have been removed in favor of a simpler counter model.

## Requirements
## REMOVED Requirements

### Requirement: Habit Type
**Reason**: User no longer wants to distinguish between positive and negative habits.
**Migration**: Existing counters will no longer have this property. Any logic relying on it will be simplified to treat all counters uniformly.

### Requirement: Habit Progress Visualization
**Reason**: Simplification of progress visualization.
**Migration**: All counters will use a single standard for goal visualization (e.g., green for met goals) regardless of their previous habit type.
