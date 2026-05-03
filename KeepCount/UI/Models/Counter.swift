
import Foundation
import SwiftData

@Model
final class Counter {
    var id: UUID
    var name: String
    var value: Int
    var initialValue: Int = 0 // Added to store the starting value for reset
    var step: Int
    var goal: Int?
    var color: String // Storing color as a hex string
    var habitType: String // "positive" or "negative"
    var category: Category?
    var isArchived: Bool = false
    var createdAt: Date = Date()
    @Relationship(deleteRule: .cascade, inverse: \HistoryEvent.counter) var history: [HistoryEvent] = []

    init(id: UUID = UUID(), name: String, value: Int = 0, initialValue: Int = 0, step: Int = 1, goal: Int? = nil, color: String = "000000", habitType: String = "positive", category: Category? = nil, isArchived: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.value = value
        self.initialValue = initialValue // Initialize with initialValue
        self.step = step
        self.goal = goal
        self.color = color
        self.habitType = habitType
        self.category = category
        self.isArchived = isArchived
        self.createdAt = createdAt
    }

    // Method to reset the counter to its initial value
    func reset() {
        let diff = self.initialValue - self.value
        if diff != 0 {
            recordEvent(change: diff)
        }
        self.value = self.initialValue
    }

    func recordEvent(change: Int) {
        let event = HistoryEvent(changeValue: change, counter: self)
        history.append(event)
    }

    var timeSinceLastEvent: String {
        guard let lastEvent = history.sorted(by: { $0.timestamp > $1.timestamp }).first else {
            return "Never"
        }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: lastEvent.timestamp, relativeTo: Date())
    }

    func generateCSV() -> String {
        var csvString = "Timestamp,Change,Total Value\n"
        let sortedHistory = history.sorted(by: { $0.timestamp < $1.timestamp })
        var runningTotal = initialValue
        for event in sortedHistory {
            runningTotal += event.changeValue
            let dateString = ISO8601DateFormatter().string(from: event.timestamp)
            csvString += "\(dateString),\(event.changeValue),\(runningTotal)\n"
        }
        return csvString
    }
}
