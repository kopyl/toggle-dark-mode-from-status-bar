import Cocoa

final class StyledButton: NSButton {

    enum Style {
        case primary
    }

    init(style: Style, title: String, icon: String, action: @escaping () -> Void) {
        super.init(frame: .zero)
        
        self.target = self
        self.action = #selector(buttonPressed)
        self.actionHandler = action
        self.isBordered = false
        self.wantsLayer = true
        self.layer?.cornerRadius = 7
        self.title = ""
        
        let titleLabel = NSTextField(labelWithString: title)
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = NSColor(named: "primaryText") ?? .labelColor
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.alignment = .center
        
        var stack: NSStackView

        if #available(macOS 11.0, *) {
            let iconImage = NSImage(systemSymbolName: icon, accessibilityDescription: nil)
            let iconView = NSImageView(image: iconImage ?? NSImage())
            iconView.symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 12, weight: .medium)
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.contentTintColor = NSColor(named: "primaryText") ?? .labelColor
            iconView.wantsLayer = true
            iconView.layer?.cornerRadius = 4
            NSLayoutConstraint.activate([
                iconView.widthAnchor.constraint(equalToConstant: 33),
                iconView.heightAnchor.constraint(equalToConstant: 25)
            ])
            stack = NSStackView(views: [titleLabel, NSView(), iconView])
        } else {
            stack = NSStackView(views: [titleLabel])
        }
        
        stack.alignment = .centerX

        stack.orientation = .horizontal
        stack.spacing = 0
        stack.edgeInsets = NSEdgeInsets(top: 0, left: 21, bottom: 0, right: 13)

        self.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        if #available(macOS 11.0, *) {
            NSLayoutConstraint.activate([
                stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
        }
        else {
            NSLayoutConstraint.activate([
                stack.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        }
        
        self.layer?.backgroundColor = NSColor.buttonBg.cgColor
        
        self.addTrackingArea(NSTrackingArea(rect: .zero,
                                            options: [.mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect],
                                            owner: self,
                                            userInfo: nil))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        if #available(macOS 11.0, *) {
            app.effectiveAppearance.performAsCurrentDrawingAppearance {
                self.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.05).cgColor
            }
        }
        else {
            self.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.05).cgColor
        }
        super.mouseDown(with: event)
        if #available(macOS 11.0, *) {
            app.effectiveAppearance.performAsCurrentDrawingAppearance {
                self.layer?.backgroundColor = NSColor.buttonBg.cgColor
            }
        }
    }
    
    override func viewDidChangeEffectiveAppearance() {
        if #available(macOS 11.0, *) {
            app.effectiveAppearance.performAsCurrentDrawingAppearance {
                self.layer?.backgroundColor = NSColor.buttonBg.cgColor
            }
        }
        else {
            self.layer?.backgroundColor = NSColor.buttonBg.cgColor
        }
    }

    private var actionHandler: (() -> Void)?

    @objc private func buttonPressed() {
        actionHandler?()
    }
}
