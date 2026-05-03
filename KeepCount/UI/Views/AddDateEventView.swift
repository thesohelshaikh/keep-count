import SwiftUI
import SwiftData

struct AddDateEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var date = Date()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Event Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
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
        let newEvent = DateEvent(name: name, date: date)
        modelContext.insert(newEvent)
    }
}
