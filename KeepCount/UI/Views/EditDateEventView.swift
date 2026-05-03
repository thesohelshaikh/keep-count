import SwiftUI
import SwiftData

struct EditDateEventView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var event: DateEvent
    
    @State private var name: String
    @State private var date: Date

    init(event: DateEvent) {
        self.event = event
        _name = State(initialValue: event.name)
        _date = State(initialValue: event.date)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Event Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("Edit Date Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEvent()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveEvent() {
        event.name = name
        event.date = date
    }
}
