
import Foundation
import SwiftData

@Model
final class Category {
    var id: UUID
    var name: String
    var order: Int?
    @Relationship(deleteRule: .cascade, inverse: \Counter.category) var counters: [Counter] = []

    init(id: UUID = UUID(), name: String, order: Int? = 0) {
        self.id = id
        self.name = name
        self.order = order
    }
}
