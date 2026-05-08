import SwiftUI
import SwiftData

struct DateTrackingView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<DateEvent> { $0.isArchived == false }, sort: \DateEvent.date, order: .reverse) private var dateEvents: [DateEvent]
    
    @State private var showingAddDateEventView = false
    @State private var showingEditDateEventView = false
    @State private var eventToEdit: DateEvent?
    @State private var showingDeleteConfirmation = false
    @State private var offsetsToDelete: IndexSet?
    @State private var listToDelete: [DateEvent]?

    private var upcomingEvents: [DateEvent] {
        dateEvents.filter { $0.date >= Calendar.current.startOfDay(for: .now) }.reversed()
    }
    private var pastEvents: [DateEvent] {
        dateEvents.filter { $0.date < Calendar.current.startOfDay(for: .now) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Upcoming") {
                    ForEach(upcomingEvents) { event in
                        eventRow(for: event)
                    }
                    .onDelete(perform: confirmDeleteUpcoming)
                }
                Section("Past") {
                    ForEach(pastEvents) { event in
                        eventRow(for: event)
                    }
                    .onDelete(perform: confirmDeletePast)
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddDateEventView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddDateEventView) {
                AddDateEventView()
            }
            .sheet(isPresented: $showingEditDateEventView) {
                if let eventToEdit = eventToEdit {
                    EditDateEventView(event: eventToEdit)
                }
            }
            .confirmationDialog(
                "Are you sure you want to delete this event?",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    deleteItems()
                }
                Button("Cancel", role: .cancel) {
                    offsetsToDelete = nil
                    listToDelete = nil
                }
            }
        }
    }
    
    private func eventRow(for event: DateEvent) -> some View {
        VStack(alignment: .leading) {
            Text(event.name).font(.headline)
            Text(event.formattedTimeDifference).font(.subheadline)
        }
        .swipeActions(edge: .leading) {
            Button {
                eventToEdit = event
                showingEditDateEventView = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
        }
        .swipeActions(edge: .trailing) {
            Button {
                event.isArchived = true
            } label: {
                Label("Archive", systemImage: "archivebox")
            }
            .tint(.orange)
        }
    }

    private func confirmDeleteUpcoming(offsets: IndexSet) {
        self.offsetsToDelete = offsets
        self.listToDelete = upcomingEvents
        self.showingDeleteConfirmation = true
    }

    private func confirmDeletePast(offsets: IndexSet) {
        self.offsetsToDelete = offsets
        self.listToDelete = pastEvents
        self.showingDeleteConfirmation = true
    }

    private func deleteItems() {
        if let offsets = offsetsToDelete, let list = listToDelete {
            withAnimation {
                for index in offsets {
                    let event = list[index]
                    NotificationManager.shared.cancelNotification(for: event)
                    modelContext.delete(event)
                }
            }
        }
    }
}
