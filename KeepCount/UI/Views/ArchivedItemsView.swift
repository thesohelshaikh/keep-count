
import SwiftUI
import SwiftData

struct ArchivedItemsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(filter: #Predicate<Counter> { $0.isArchived == true }) private var archivedCounters: [Counter]
    @Query(filter: #Predicate<DateEvent> { $0.isArchived == true }) private var archivedEvents: [DateEvent]
    
    @State private var counterToDelete: Counter?
    @State private var eventToDelete: DateEvent?
    @State private var showingCounterDeleteConfirmation = false
    @State private var showingEventDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                if archivedCounters.isEmpty && archivedEvents.isEmpty {
                    ContentUnavailableView {
                        Label("No Archived Items", systemImage: "archivebox")
                    } description: {
                        Text("Archived counters and events will appear here.")
                    }
                } else {
                    if !archivedCounters.isEmpty {
                        Section("Counters") {
                            ForEach(archivedCounters) { counter in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(counter.name)
                                            .font(.headline)
                                        Text("Total: \(counter.value)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Button(action: {
                                        counter.isArchived = false
                                    }) {
                                        Label("Restore", systemImage: "arrow.up.bin")
                                            .labelStyle(.iconOnly)
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.blue)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        counterToDelete = counter
                                        showingCounterDeleteConfirmation = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    
                    if !archivedEvents.isEmpty {
                        Section("Events") {
                            ForEach(archivedEvents) { event in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(event.name)
                                            .font(.headline)
                                        Text(event.formattedTimeDifference)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Button(action: {
                                        event.isArchived = false
                                    }) {
                                        Label("Restore", systemImage: "arrow.up.bin")
                                            .labelStyle(.iconOnly)
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.blue)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        eventToDelete = event
                                        showingEventDeleteConfirmation = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Archived Items")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .confirmationDialog("Delete Counter?", isPresented: $showingCounterDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    if let counter = counterToDelete {
                        modelContext.delete(counter)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete '\(counterToDelete?.name ?? "")' and all its history.")
            }
            .confirmationDialog("Delete Event?", isPresented: $showingEventDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    if let event = eventToDelete {
                        modelContext.delete(event)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete '\(eventToDelete?.name ?? "")'.")
            }
        }
    }
}

#Preview {
    ArchivedItemsView()
        .modelContainer(for: [Counter.self, DateEvent.self], inMemory: true)
}
