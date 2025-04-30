import Cocoa

let mainWindowWidth: CGFloat = 500
let mainWindowHeight: CGFloat = 500

final class GreetingView: NSView {
    
    private let appIconSize: CGFloat = 96
    private let verticalSpacing: CGFloat = 18
    private let topPadding: CGFloat = 48
    private let bottomPadding: CGFloat = 26
    private let horizontalPadding: CGFloat = 26
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let mainStack = NSStackView()
        mainStack.orientation = .vertical
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.alignment = .centerX
        mainStack.spacing = 0
        
        let innerStack = NSStackView()
        innerStack.orientation = .vertical
        innerStack.spacing = verticalSpacing
        innerStack.alignment = .centerX
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = NSImageView(image: NSApp.applicationIconImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.widthAnchor.constraint(equalToConstant: appIconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: appIconSize).isActive = true
        
        let titleLabel = NSTextField(labelWithString: "Toggle Dark Mode from Menu Bar")
        titleLabel.font = NSFont.systemFont(ofSize: 20)
        titleLabel.textColor = NSColor.labelColor
        titleLabel.alignment = .center
        
        innerStack.addArrangedSubview(imageView)
        innerStack.addArrangedSubview(titleLabel)
        
        let spacer = NSView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        let hideButton = StyledButton(
            style: .primary,
            title: "Hide app in background",
            icon: "return"
        ) {
            NSApp.setActivationPolicy(.accessory)
        }
        hideButton.keyEquivalent = "\r"
        hideButton.translatesAutoresizingMaskIntoConstraints = false

        let buttonContainer = NSView()
        self.addSubview(hideButton)
        
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hideButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            hideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            hideButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            hideButton.heightAnchor.constraint(equalToConstant: 49)
        ])
        
        let topPaddingView = NSView()
        topPaddingView.translatesAutoresizingMaskIntoConstraints = false
        topPaddingView.heightAnchor.constraint(equalToConstant: topPadding).isActive = true
        
        let bottomPaddingView = NSView()
        bottomPaddingView.translatesAutoresizingMaskIntoConstraints = false
        bottomPaddingView.heightAnchor.constraint(equalToConstant: bottomPadding).isActive = true

        mainStack.addArrangedSubview(topPaddingView)
        mainStack.addArrangedSubview(innerStack)
        mainStack.addArrangedSubview(spacer)
        mainStack.addArrangedSubview(buttonContainer)
        mainStack.addArrangedSubview(bottomPaddingView)

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func hideApp() {
        NSApp.setActivationPolicy(.accessory)
    }
}

final class GreetingViewController: NSViewController {

    override func loadView() {
        self.view = GreetingView(frame: NSRect(x: 0, y: 0, width: 400, height: 300))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
