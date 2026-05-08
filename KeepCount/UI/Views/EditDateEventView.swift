import SwiftUI
import SwiftData

struct EditDateEventView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var event: DateEvent
    
    @State private var name: String
    @State private var date: Date
    @State private var shouldNotify: Bool

    init(event: DateEvent) {
        self.event = event
        _name = State(initialValue: event.name)
        _date = State(initialValue: event.date)
        _shouldNotify = State(initialValue: event.shouldNotify)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Event Name", text: $name)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Toggle("Notify me on the day", isOn: $shouldNotify)
                        .onChange(of: shouldNotify) { oldValue, newValue in
                            if newValue {
                                NotificationManager.shared.requestAuthorization()
                            }
                        }
                }
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
        event.shouldNotify = shouldNotify
        NotificationManager.shared.scheduleNotification(for: event)
    }
}
