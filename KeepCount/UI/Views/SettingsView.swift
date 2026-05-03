
import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showingArchivedItems = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Data Management")) {
                    NavigationLink {
                        CategoryListView()
                    } label: {
                        Label("Manage Categories", systemImage: "folder.fill")
                    }
                    
                    Button {
                        showingArchivedItems = true
                    } label: {
                        Label("Manage Archived Items", systemImage: "archivebox.fill")
                    }
                }
                
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingArchivedItems) {
                ArchivedItemsView()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
