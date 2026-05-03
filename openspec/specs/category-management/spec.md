# category-management Specification

## Purpose
The Category Management capability allows users to organize their counters into meaningful groups. This specification covers editing and reordering categories.

## Requirements

### Requirement: Edit Category Name
The system SHALL allow users to edit the name of a category.

#### Scenario: Successful Edit
- **WHEN** a user changes the name of a category and saves it
- **THEN** the category's name MUST be updated in the system
- **AND** all views displaying the category name MUST reflect the new name.

#### Scenario: Edit with Empty Name
- **WHEN** a user attempts to save a category with an empty name
- **THEN** the system SHALL prevent the save
- **AND** an error message SHALL be displayed to the user.

### Requirement: Reorder Categories
The system SHALL allow users to reorder categories.

#### Scenario: Successful Reorder
- **WHEN** a user drags and drops a category to a new position in the list
- **THEN** the order of the categories in the system MUST be updated to reflect the new order.
- **AND** all views displaying the list of categories MUST reflect the new order.
