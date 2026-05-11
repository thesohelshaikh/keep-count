
import SwiftUI
import SwiftData
import Charts

struct HistoryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let counter: Counter
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingManualEntry = false
    @State private var manualAmount: Int = 1
    @State private var manualDate: Date = Date()
    @State private var itemToDelete: HistoryEvent?
    @State private var showingDeleteConfirmation = false
    @State private var selectedRange: TimeRange = .week

    enum TimeRange: String, CaseIterable, Identifiable {
        case day = "D"
        case week = "W"
        case month = "M"
        case sixMonths = "6M"
        case year = "Y"
        var id: String { self.rawValue }
        
        var calendarComponent: Calendar.Component {
            switch self {
            case .day: return .hour
            case .week, .month: return .day
            case .sixMonths: return .weekOfYear
            case .year: return .month
            }
        }
        
        var rangeCount: Int {
            switch self {
            case .day: return 24
            case .week: return 7
            case .month: return 30
            case .sixMonths: return 26
            case .year: return 12
            }
        }
    }

    var sortedHistory: [HistoryEvent] {
        counter.history.sorted(by: { $0.timestamp > $1.timestamp })
    }

    private var bucketedData: [(date: Date, total: Int)] {
        let calendar = Calendar.current
        let now = Date()
        var results: [(date: Date, total: Int)] = []
        
        // Create buckets
        for i in 0..<selectedRange.rangeCount {
            if let date = calendar.date(byAdding: selectedRange.calendarComponent, value: -i, to: now) {
                // Normalize date to the start of the component
                let components = calendar.dateComponents(selectedRange.calendarComponent == .weekOfYear ? [.yearForWeekOfYear, .weekOfYear] : (selectedRange.calendarComponent == .hour ? [.year, .month, .day, .hour] : (selectedRange.calendarComponent == .month ? [.year, .month] : [.year, .month, .day])), from: date)
                if let bucketDate = calendar.date(from: components) {
                    results.append((bucketDate, 0))
                }
            }
        }
        
        results.reverse()
        
        // Fill buckets
        for event in counter.history {
            let components = calendar.dateComponents(selectedRange.calendarComponent == .weekOfYear ? [.yearForWeekOfYear, .weekOfYear] : (selectedRange.calendarComponent == .hour ? [.year, .month, .day, .hour] : (selectedRange.calendarComponent == .month ? [.year, .month] : [.year, .month, .day])), from: event.timestamp)
            if let eventDate = calendar.date(from: components) {
                if let index = results.firstIndex(where: { $0.date == eventDate }) {
                    results[index].total += event.changeValue
                }
            }
        }
        
        return results
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 16) {
                        Picker("Time Range", selection: $selectedRange) {
                            ForEach(TimeRange.allCases) { range in
                                Text(range.rawValue).tag(range)
                            }
                        }
                        .pickerStyle(.segmented)

                        Chart {
                            ForEach(bucketedData, id: \.date) { item in
                                BarMark(
                                    x: .value("Date", item.date, unit: selectedRange.calendarComponent),
                                    y: .value("Total", item.total)
                                )
                                .foregroundStyle(Color(hex: counter.color))
                                .cornerRadius(4)
                            }
                        }
                        .frame(height: 180)
                        .chartXAxis {
                            switch selectedRange {
                            case .day:
                                AxisMarks(values: .stride(by: .hour, count: 6)) { value in
                                    AxisValueLabel(format: .dateTime.hour())
                                }
                            case .week:
                                AxisMarks(values: .stride(by: .day, count: 1)) { value in
                                    AxisValueLabel(format: .dateTime.weekday(.narrow))
                                }
                            case .month:
                                AxisMarks(values: .stride(by: .day, count: 7)) { value in
                                    AxisValueLabel(format: .dateTime.day())
                                }
                            case .sixMonths:
                                AxisMarks(values: .stride(by: .month, count: 1)) { value in
                                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                                }
                            case .year:
                                AxisMarks(values: .stride(by: .month, count: 1)) { value in
                                    AxisValueLabel(format: .dateTime.month(.narrow))
                                }
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                    }
                    .padding(.vertical, 8)
                    .accessibilityLabel("Counter activity chart")
                    .accessibilityValue("Showing \(selectedRange.rawValue) activity for \(counter.name).")
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))

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
                                    HStack(spacing: 4) {
                                        Text(entry.event.timestamp, style: .time)
                                        if let interval = entry.interval {
                                            Text("•")
                                            Text(interval)
                                        }
                                    }
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
