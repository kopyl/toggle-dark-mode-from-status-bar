import OSAKit
import SwiftUI

let script = """
tell application "System Events"
    tell appearance preferences
        set dark mode to not dark mode
    end tell
end tell
"""

var mainWindow: NSWindow?
var statusBarItem: NSStatusItem?

func runScript() {
    let script = OSAScript(source: script, language: OSALanguage.default())
    var error: NSDictionary?
    script.executeAndReturnError(&error)
}


class Window: NSWindow {
    init(view: some NSViewController, styleMask: NSWindow.StyleMask = [.closable, .titled]) {
        super.init(
            contentRect: .zero,
            styleMask: styleMask,
            backing: .buffered,
            defer: false
        )
        self.titlebarAppearsTransparent = true
        self.contentViewController = view
        self.titlebarAppearsTransparent = true
        
        let _ = NSWindowController(window: self)
    }
    
    override var canBecomeKey: Bool {
        return true
    }
}

func createMaiWindow() {
    mainWindow = Window(view: GreetingViewController())
    mainWindow?.setContentSize(NSSize(width: mainWindowWidth, height: mainWindowHeight))
    mainWindow?.backgroundColor = .appBg
    let _ = NSWindowController(window: mainWindow)
}

func showMainWindow() {
    mainWindow?.makeKeyAndOrderFront(nil)
    mainWindow?.center()
}

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    private var statusBarMenu: NSMenu?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        addStatusBarItem()
        createMaiWindow()
        showMainWindow()
    }
    
    private func addStatusBarItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        guard let button = statusBarItem?.button else { return }
        button.image = NSImage(named: "status-bar-icon")
        button.image?.isTemplate = true
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Move app in foreground", action: #selector(moveAppOutOfBackground), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        menu.delegate = self
        
        self.statusBarMenu = menu
        
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        button.target = self
        button.action = #selector(statusBarItemClicked)
    }
    
    @objc func statusBarItemClicked(sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == .rightMouseUp {
            statusBarItem?.menu = statusBarMenu
            sender.performClick(nil)
            statusBarItem?.menu = nil
        } else if event.type == .leftMouseUp {
            
            runScript()
        }
    }
    
    @objc func moveAppOutOfBackground() {
        NSApp.setActivationPolicy(.regular)
        
        let appID = Bundle.main.bundleIdentifier ?? ""
        if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: appID) {
            NSWorkspace.shared.open(appURL)
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

let app = Application.shared
let delegate = AppDelegate()
app.delegate = delegate

app.run()
