
import SwiftUI
import SwiftData

struct EditCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var category: Category
    
    @State private var name: String = ""
    @State private var showingError = false
    @State private var errorMessage = ""

    var body: some View {
        Form {
            Section(header: Text("Category Name")) {
                TextField("Name", text: $name)
                    .onAppear {
                        name = category.name
                    }
            }
        }
        .navigationTitle("Edit Category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    save()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert("Invalid Name", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            errorMessage = "Category name cannot be empty."
            showingError = true
            return
        }
        
        category.name = trimmedName
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Category.self, configurations: config)
    let example = Category(name: "Example")
    return NavigationStack {
        EditCategoryView(category: example)
            .modelContainer(container)
    }
}
