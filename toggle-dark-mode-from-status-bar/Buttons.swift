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
        self.layer?.cornerRadius = 5
        self.title = ""
        
        let font = NSFont.systemFont(ofSize: 14)
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: 0.3,
            .font: font
        ]
        let titleLabel = NSTextField(labelWithString: title)
        titleLabel.font = font
        titleLabel.textColor = NSColor(named: "primaryText") ?? .labelColor
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.alignment = .center
        titleLabel.attributedStringValue = NSAttributedString(string: title, attributes: attributes)
        
        var stack: NSStackView

        if #available(macOS 11.0, *) {
            let iconImage = NSImage(systemSymbolName: icon, accessibilityDescription: nil)
            let iconView = NSImageView(image: iconImage ?? NSImage())
            iconView.symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 13, weight: .medium)
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.contentTintColor = NSColor(named: "primaryText") ?? .labelColor
            iconView.wantsLayer = true
            iconView.widthAnchor.constraint(equalToConstant: 33).isActive = true
            stack = NSStackView(views: [titleLabel, NSView(), iconView])
            iconView.centerYAnchor.constraint(equalTo: stack.centerYAnchor).isActive = true
        } else {
            stack = NSStackView(views: [titleLabel])
        }

        stack.orientation = .horizontal
        stack.spacing = 0
        
        if #available(macOS 11.0, *) {
            stack.edgeInsets = NSEdgeInsets(top: 0, left: 18, bottom: 0, right: 11)
        }

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
        
        self.layer?.backgroundColor = NSColor.buttonBg.cgColorAppearanceFix
        
        self.addTrackingArea(NSTrackingArea(rect: .zero,
                                            options: [.mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect],
                                            owner: self,
                                            userInfo: nil))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        self.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.05).cgColorAppearanceFix
        super.mouseDown(with: event)
        self.layer?.backgroundColor = NSColor.buttonBg.cgColorAppearanceFix
    }
    
    override func viewDidChangeEffectiveAppearance() {
        self.layer?.backgroundColor = NSColor.buttonBg.cgColorAppearanceFix
    }

    private var actionHandler: (() -> Void)?

    @objc private func buttonPressed() {
        actionHandler?()
    }
}
