
import SwiftUI
import SwiftData

@main
struct keep_countApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Counter.self,
            Category.self,
            HistoryEvent.self,
            DateEvent.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .onAppear {
                    migrateCategories()
                }
        }
        .modelContainer(sharedModelContainer)
    }

    private func migrateCategories() {
        let context = sharedModelContainer.mainContext
        let descriptor = FetchDescriptor<Category>()
        
        do {
            let categories = try context.fetch(descriptor)
            
            // Migrate if any category has a nil order or if they all have the same order
            let needsMigration = categories.contains { $0.order == nil } || 
                               (categories.count > 1 && Set(categories.map { $0.order ?? 0 }).count < categories.count)
            
            if needsMigration {
                // Sort them alphabetically by name for the initial stable order
                let sortedByName = categories.sorted { $0.name < $1.name }
                for (index, category) in sortedByName.enumerated() {
                    category.order = index
                }
                try context.save()
            }
        } catch {
            print("Failed to migrate categories: \(error)")
        }
    }
}
