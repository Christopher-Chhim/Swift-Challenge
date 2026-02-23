import SwiftUI

@main
struct PathwaysApp: App {
    @State private var store = AppDataStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
            }
            .environment(\.appDataStore, store)
        }
    }
}
