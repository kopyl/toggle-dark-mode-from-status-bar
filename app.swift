import Cocoa

class Application: NSApplication {
    func addQuiteMenuItem() {
        self.mainMenu = NSMenu()
        
        let appMenuItem = NSMenuItem()
        self.mainMenu?.addItem(appMenuItem)
        
        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu
        
        appMenu.addItem(NSMenuItem(title: "Quit \(ProcessInfo.processInfo.processName)",
           action: #selector(terminate(_:)),
           keyEquivalent: "q")
        )
    }
    
    override init() {
        super.init()
        self.addQuiteMenuItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
