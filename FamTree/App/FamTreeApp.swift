import SwiftUI
import SwiftData

@main
struct FamTreeApp: App {
    var body: some Scene {
        WindowGroup { RootView() }
            .modelContainer(for: Person.self) // SwiftData ローカル保存
    }
}

