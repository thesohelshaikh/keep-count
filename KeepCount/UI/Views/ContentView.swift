
import SwiftUI
import SwiftData
import UIKit // Import UIKit for haptic feedback

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [Category]
    @Query private var allCounters: [Counter]
    
    @State private var showingAddCounter = false
    @State private var counterToEdit: Counter? // State for editing counter
    @State private var selectedCounterForHistory: Counter? // State for showing history
    @State private var searchText = ""
    @State private var counterToDelete: Counter?
    @State private var showingCounterDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            Group {
                if allCounters.isEmpty {
                    ContentUnavailableView {
                        Label("No Counters", systemImage: "number.circle")
                    } description: {
                        Text("Add a counter to start tracking.")
                    } actions: {
                        Button("Add Your First Counter") {
                            showingAddCounter = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        let filteredCounters = allCounters.filter {
                            searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText)
                        }
                        
                        // Grouped counters by category
                        let grouped = Dictionary(grouping: filteredCounters, by: { $0.category })
                        
                        // Categories from the grouping (sorted by name)
                        let sortedCategories = categories.sorted(by: { $0.name < $1.name })
                        
                        ForEach(sortedCategories) { category in
                            if let countersInCategory = grouped[category], !countersInCategory.isEmpty {
                                Section(header: Text(category.name)) {
                                    ForEach(countersInCategory) { counter in
                                        counterRowView(for: counter)
                                    }
                                    .onDelete { indices in
                                        if let index = indices.first {
                                            counterToDelete = countersInCategory[index]
                                            showingCounterDeleteConfirmation = true
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Uncategorized counters
                        if let uncategorized = grouped[nil], !uncategorized.isEmpty {
                            Section(header: Text("General")) {
                                ForEach(uncategorized) { counter in
                                    counterRowView(for: counter)
                                }
                                .onDelete { indices in
                                    if let index = indices.first {
                                        counterToDelete = uncategorized[index]
                                        showingCounterDeleteConfirmation = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Keep Count")
            .searchable(text: $searchText, prompt: "Search counters")
            .confirmationDialog("Are you sure you want to delete this counter?", isPresented: $showingCounterDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    if let counter = counterToDelete {
                        let category = counter.category
                        modelContext.delete(counter)
                        
                        // Clean up empty category if needed
                        if let category = category, category.counters.isEmpty {
                            modelContext.delete(category)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                if let counter = counterToDelete {
                    Text("This will permanently delete '\(counter.name)' and all its history.")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddCounter = true }) {
                        Label("Add Counter", systemImage: "plus")
                    }
                }
            }
            // Sheets for adding/editing
            .sheet(isPresented: $showingAddCounter) {
                AddCounterView()
            }
            .sheet(item: $counterToEdit) { counter in
                AddCounterView(counterToEdit: counter)
            }
            .sheet(item: $selectedCounterForHistory) { counter in
                HistoryDetailView(counter: counter)
            }
        }
    }

    @ViewBuilder
    private func counterRowView(for counter: Counter) -> some View {
        Button(action: {
            selectedCounterForHistory = counter // Show history on row tap
        }) {
            CounterRow(counter: counter)
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .leading) {
            Button {
                counterToEdit = counter
            } label: {
                Label("Edit", systemImage: "pencil")
            }
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

    private func deleteCategory(at offsets: IndexSet) {
        for index in offsets {
            let categoryToDelete = categories[index]
            modelContext.delete(categoryToDelete)
        }
    }
}

// CounterRow struct
struct CounterRow: View {
    @Bindable var counter: Counter
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    private var isGoalMet: Bool {
        guard let goal = counter.goal else { return false }
        return goal > 0 && counter.value >= goal
    }

    var body: some View {
        HStack {
            Circle()
                .fill(isGoalMet ? Color.green : Color(hex: counter.color))
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(counter.name)
                    .font(.headline)
                    .foregroundColor(isGoalMet ? .green : .primary)
                
                HStack(spacing: 8) {
                    Text("\(counter.value)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .monospacedDigit()
                    
                    Text("Last: \(counter.timeSinceLastEvent)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(isGoalMet ? .green : .primary)

                if let goal = counter.goal {
                    ProgressView(value: Double(counter.value), total: Double(goal))
                        .tint(isGoalMet ? (counter.habitType == "negative" ? .red : .green) : Color(hex: counter.color))
                        .scaleEffect(x: 1, y: 0.5, anchor: .center)
                }
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: {
                    counter.value -= counter.step
                    counter.recordEvent(change: -counter.step)
                    feedbackGenerator.impactOccurred()
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color(hex: counter.color))
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("Decrement \(counter.name)")
                
                Button(action: {
                    counter.value += counter.step
                    counter.recordEvent(change: counter.step)
                    feedbackGenerator.impactOccurred()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color(hex: counter.color))
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("Increment \(counter.name)")
            }
        }
        .padding(.vertical, 4)
    }
}

// Color extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(a * 255), lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

// Preview provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: [Counter.self, Category.self, HistoryEvent.self], inMemory: true)
    }
}
