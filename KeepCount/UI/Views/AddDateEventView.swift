import SwiftUI
import SwiftData

struct AddDateEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var date = Date()
    @State private var shouldNotify = false

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
            .navigationTitle("Add Date Event")
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
        let newEvent = DateEvent(name: name, date: date, shouldNotify: shouldNotify)
        modelContext.insert(newEvent)
        NotificationManager.shared.scheduleNotification(for: newEvent)
    }
}
