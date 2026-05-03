
import SwiftUI

struct MainTabView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Counters", systemImage: "list.bullet")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .modelContainer(for: [Counter.self, Category.self, HistoryEvent.self], inMemory: true)
    }
}
