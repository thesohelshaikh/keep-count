
import SwiftUI
import SwiftData

struct CategoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Category.order, order: .forward), SortDescriptor(\Category.name, order: .forward)]) private var categories: [Category]
    
    @State private var categoryToEdit: Category?

    var body: some View {
        List {
            Section {
                HStack {
                    Text("General")
                    Spacer()
                    Text("\(uncategorizedCount) counters")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(.secondary)
            } header: {
                Text("Default Group")
            } footer: {
                Text("'General' contains all counters without a category. It cannot be renamed or reordered.")
            }

            Section {
                ForEach(categories) { category in
                    NavigationLink {
                        EditCategoryView(category: category)
                    } label: {
                        HStack {
                            Text(category.name)
                            Spacer()
                            Text("\(category.counters.count) counters")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: deleteCategories)
            } header: {
                Text("Categories")
            } footer: {
                Text("Drag categories to reorder them.")
            }
        }
        .navigationTitle("Manage Categories")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
    }

    @Query(filter: #Predicate<Counter> { $0.category == nil }) private var uncategorizedCounters: [Counter]
    
    private var uncategorizedCount: Int {
        uncategorizedCounters.count
    }

    private func move(from source: IndexSet, to destination: Int) {
        var revisedItems = categories
        revisedItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in revisedItems.enumerated() {
            item.order = index
        }
        
        try? modelContext.save()
    }

    private func deleteCategories(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(categories[index])
        }
        
        // After deletion, re-index to maintain sequential order
        let remaining = categories.enumerated().filter { !offsets.contains($0.offset) }.map { $0.element }
        for (index, category) in remaining.enumerated() {
            category.order = index
        }
        
        try? modelContext.save()
    }
}

#Preview {
    CategoryListView()
        .modelContainer(for: Category.self, inMemory: true)
}
