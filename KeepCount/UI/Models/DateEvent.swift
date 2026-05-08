import Foundation
import SwiftData

@Model
final class DateEvent {
    var id: UUID
    var name: String
    var date: Date
    var isArchived: Bool = false
    var shouldNotify: Bool = false

    init(name: String, date: Date, isArchived: Bool = false, shouldNotify: Bool = false) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.isArchived = isArchived
        self.shouldNotify = shouldNotify
    }

    var formattedTimeDifference: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let eventDay = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.year, .month, .day], from: today, to: eventDay)
        
        let years = abs(components.year ?? 0)
        let months = abs(components.month ?? 0)
        let days = abs(components.day ?? 0)

        if years == 0 && months == 0 && days == 0 {
            return "Today"
        }

        var result = ""
        if years > 0 {
            result = pluralize(count: years, singular: "year")
            if months > 0 {
                result += ", \(pluralize(count: months, singular: "month"))"
            }
        } else if months > 0 {
            result = pluralize(count: months, singular: "month")
            if days > 0 {
                result += ", \(pluralize(count: days, singular: "day"))"
            }
        } else {
            result = pluralize(count: days, singular: "day")
        }

        if eventDay < today {
            return "\(result) since"
        } else {
            return "\(result) until"
        }
    }

    private func pluralize(count: Int, singular: String) -> String {
        return "\(count) \(singular)\(count == 1 ? "" : "s")"
    }
}
