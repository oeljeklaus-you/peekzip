import AppKit
import SwiftUI

@main
struct PeekZipApp: App {
    @NSApplicationDelegateAdaptor(PeekZipAppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        Settings {
            SettingsView()
        }
    }
}

final class PeekZipAppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let icon = NSImage(named: "AppIcon") {
            NSApp.applicationIconImage = icon
        }
        PurchaseManager.shared.configureIfNeeded()
        hideWindowTitles()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        hideWindowTitles()
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        guard let url = urls.first else {
            return
        }

        ArchiveStore.shared.loadArchive(url: url)
    }

    private func hideWindowTitles() {
        DispatchQueue.main.async {
            NSApp.windows.forEach { window in
                window.title = ""
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = false
            }
        }
    }
}
