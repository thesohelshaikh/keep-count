
import SwiftUI
import SwiftData

struct HistoryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let counter: Counter
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingManualEntry = false
    @State private var manualAmount: Int = 1
    @State private var manualDate: Date = Date()
    @State private var itemToDelete: HistoryEvent?
    @State private var showingDeleteConfirmation = false

    var sortedHistory: [HistoryEvent] {
        counter.history.sorted(by: { $0.timestamp > $1.timestamp })
    }

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Details")) {
                    LabeledContent("Total Value", value: "\(counter.value)")
                    if let goal = counter.goal {
                        LabeledContent("Goal", value: "\(goal)")
                    }
                    LabeledContent("Created on", value: counter.createdAt.formatted(date: .long, time: .omitted))
                    LabeledContent("Last Activity", value: counter.exactTimeSinceLastEvent)
                }

                Section(header: Text("History")) {
                    Button(action: { showingManualEntry = true }) {
                        Label("Add Manual Entry", systemImage: "calendar.badge.plus")
                    }
                    .accessibilityLabel("Add manual entry to history")
                    
                    if counter.history.isEmpty {
                        Text("No events yet")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(counter.historyWithTotals, id: \.event.id) { entry in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(entry.event.timestamp, style: .date)
                                    Text(entry.event.timestamp, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(entry.event.changeValue > 0 ? "+\(entry.event.changeValue)" : "\(entry.event.changeValue)")
                                        .foregroundColor(entry.event.changeValue > 0 ? .green : .red)
                                        .bold()
                                    Text("Total: \(entry.total)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(entry.event.timestamp.formatted()), change of \(entry.event.changeValue), total is now \(entry.total)")
                        }
                        .onDelete { offsets in
                            if let index = offsets.first {
                                itemToDelete = counter.historyWithTotals[index].event
                                showingDeleteConfirmation = true
                            }
                        }
                    }
                }
            }
            .navigationTitle(counter.name)
            .confirmationDialog("Are you sure you want to delete this entry?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    if let item = itemToDelete {
                        deleteHistoryItem(item)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                if let item = itemToDelete {
                    Text("This will change the counter total by \(item.changeValue * -1).")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        ShareLink(item: counter.generateCSV(), subject: Text("\(counter.name) Export"), message: Text("Counter history export for \(counter.name)")) {
                            Label("Export", systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingManualEntry) {
                manualEntrySheet
            }
        }
    }

    private var manualEntrySheet: some View {
        NavigationStack {
            Form {
                Section(header: Text("Entry Details")) {
                    DatePicker("Date", selection: $manualDate, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                    Stepper("Amount: \(manualAmount > 0 ? "+" : "")\(manualAmount)", value: $manualAmount, in: -1000...1000)
                }
            }
            .navigationTitle("Manual Entry")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { showingManualEntry = false }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        addManualEntry()
                        showingManualEntry = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func addManualEntry() {
        let event = HistoryEvent(timestamp: manualDate, changeValue: manualAmount, counter: counter)
        counter.history.append(event)
        counter.value += manualAmount
    }

    private func deleteHistoryItem(_ event: HistoryEvent) {
        counter.value -= event.changeValue
        modelContext.delete(event)
    }
}
