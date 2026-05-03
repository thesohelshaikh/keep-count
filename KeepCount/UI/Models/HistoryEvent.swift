
import Foundation
import SwiftData

@Model
final class HistoryEvent {
    var id: UUID
    var timestamp: Date
    var changeValue: Int
    var counter: Counter?

    init(id: UUID = UUID(), timestamp: Date = Date(), changeValue: Int, counter: Counter? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.changeValue = changeValue
        self.counter = counter
    }
}
