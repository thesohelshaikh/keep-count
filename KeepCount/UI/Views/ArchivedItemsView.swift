
import SwiftUI
import SwiftData

struct ArchivedItemsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(filter: #Predicate<Counter> { $0.isArchived == true }) private var archivedCounters: [Counter]
    @Query(filter: #Predicate<DateEvent> { $0.isArchived == true }) private var archivedEvents: [DateEvent]

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
                                        let category = counter.category
                                        modelContext.delete(counter)
                                        
                                        // Clean up empty category if needed
                                        if let category = category, category.counters.isEmpty {
                                            modelContext.delete(category)
                                        }
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
                                        NotificationManager.shared.cancelNotification(for: event)
                                        modelContext.delete(event)
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
        }
    }
}

#Preview {
    ArchivedItemsView()
        .modelContainer(for: [Counter.self, DateEvent.self], inMemory: true)
}
