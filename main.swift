import Cocoa

var mainWindow: NSWindow?

func createMaiWindow() {
    mainWindow = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable],
        backing: .buffered, defer: false)
    
    let viewController = MainViewController()
    mainWindow?.contentViewController = viewController
}

func showMainWindow() {
    mainWindow?.makeKeyAndOrderFront(nil)
    mainWindow?.center()
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var globalKeyMonitor: Any?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        createMaiWindow()
        showMainWindow()
    }

}

let app = Application.shared
let delegate = AppDelegate()
app.delegate = delegate

app.run()
