import Cocoa
import OSAKit

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

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    private var statusBarMenu: NSMenu?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        addStatusBarItem()
    }
    
    private func addStatusBarItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        guard let button = statusBarItem?.button else { return }
        button.image = NSImage(named: "status-bar-icon")
        button.image?.isTemplate = true
        
        let menu = NSMenu()
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
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

app.run()
