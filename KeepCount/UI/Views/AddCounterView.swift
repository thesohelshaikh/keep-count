
import SwiftUI
import SwiftData

struct AddCounterView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Query private var categories: [Category]

    // Optional: to edit an existing counter
    var counterToEdit: Counter?

    // State variables for the form
    @State private var name: String
    @State private var initialValue: Int
    @State private var step: Int
    @State private var goal: Int?
    @State private var color: Color
    @State private var selectedCategory: Category?
    @State private var newCategoryName: String = ""
    @State private var isCreatingNewCategory: Bool = false

    // Initializer for adding a new counter
    init() {
        self._name = State(initialValue: "")
        self._initialValue = State(initialValue: 0)
        self._step = State(initialValue: 1)
        self._goal = State(initialValue: nil)
        self._color = State(initialValue: .blue)
        self._selectedCategory = State(initialValue: nil)
        self._newCategoryName = State(initialValue: "")
        self._isCreatingNewCategory = State(initialValue: false)
    }

    // Initializer for editing an existing counter
    init(counterToEdit: Counter) {
        self.counterToEdit = counterToEdit
        self._name = State(initialValue: counterToEdit.name)
        self._initialValue = State(initialValue: counterToEdit.initialValue)
        self._step = State(initialValue: counterToEdit.step)
        // Convert hex color string to Color (relies on Color extension in ContentView.swift)
        self._color = State(initialValue: Color(hex: counterToEdit.color))
        self._goal = State(initialValue: counterToEdit.goal)
        // Set selected category. Need to fetch categories first.
        // For now, assume selectedCategory will be handled after categories are fetched.
        self._selectedCategory = State(initialValue: counterToEdit.category)
        self._newCategoryName = State(initialValue: "")
        self._isCreatingNewCategory = State(initialValue: false)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Counter Details")) {
                    TextField("Name", text: $name)
                    TextField("Initial Value", value: $initialValue, format: .number)
                        .keyboardType(.numberPad)
                    Stepper("Step: \(step)", value: $step, in: 1...100)
                    TextField("Goal (Optional)", value: $goal, format: .number)
                        .keyboardType(.numberPad)
                    ColorPicker("Color", selection: $color)
                }

                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $selectedCategory) {
                        Text("None").tag(nil as Category?)
                        ForEach(categories) { category in
                            Text(category.name).tag(category as Category?)
                        }
                    }
                    .disabled(isCreatingNewCategory)
                    
                    if !isCreatingNewCategory {
                        Button(action: { isCreatingNewCategory = true }) {
                            Label("Create New Category", systemImage: "plus.circle")
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("New Category Name", text: $newCategoryName)
                                .textFieldStyle(.roundedBorder)
                            
                            Button("Cancel") {
                                isCreatingNewCategory = false
                                newCategoryName = ""
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle(counterToEdit == nil ? "Add Counter" : "Edit Counter")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveCounter()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || (isCreatingNewCategory && newCategoryName.isEmpty))
                }
            }
        }
    }

    private func saveCounter() {
        var finalCategory = selectedCategory
        
        if isCreatingNewCategory && !newCategoryName.isEmpty {
            let newCategory = Category(name: newCategoryName)
            modelContext.insert(newCategory)
            finalCategory = newCategory
        }

        if let counter = counterToEdit {
            // Editing existing counter
            counter.name = name
            counter.initialValue = initialValue
            counter.value = initialValue // Reset current value when editing initial value
            counter.step = step
            counter.goal = goal
            counter.color = color.toHex() ?? "000000" // Relies on Color extension being accessible
            
            // Update relationships on both sides
            if counter.category != finalCategory {
                counter.category?.counters.removeAll(where: { $0.id == counter.id })
                counter.category = finalCategory
                finalCategory?.counters.append(counter)
            }
        } else {
            // Adding new counter
            let newCounter = Counter(
                name: name,
                value: initialValue, // Set current value to initialValue
                initialValue: initialValue, // Set initialValue
                step: step,
                goal: goal,
                color: color.toHex() ?? "000000", // Relies on Color extension being accessible
                category: finalCategory
            )
            modelContext.insert(newCounter)
            finalCategory?.counters.append(newCounter)
        }
    }
}

// Color extension removed from here. It is defined in ContentView.swift.

struct AddCounterView_Previews: PreviewProvider {
    static var previews: some View {
        AddCounterView()
            .modelContainer(for: [Counter.self, Category.self, HistoryEvent.self], inMemory: true)
    }
}
