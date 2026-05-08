import SwiftUI
import SwiftData

struct DateTrackingView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<DateEvent> { $0.isArchived == false }, sort: \DateEvent.date, order: .reverse) private var dateEvents: [DateEvent]
    
    @State private var showingAddDateEventView = false
    @State private var showingEditDateEventView = false
    @State private var eventToEdit: DateEvent?

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
                }
                Section("Past") {
                    ForEach(pastEvents) { event in
                        eventRow(for: event)
                    }
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
}
