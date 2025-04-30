import SwiftUI

let mainWindowWidth: CGFloat = 500
let mainWindowHeight: CGFloat = 500

struct Greetingview: View {
    var body: some View {
        VStack {
            VStack(spacing: 18) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 96, height: 96)
                Text("Toggle Dark Mode from Menu Bar")
                    .font(.system(size: 20))
                    .foregroundStyle(.primaryText)
            }
            .padding(.top, 48)
            Spacer()
            StyledButton(.primary, "Hide app in background", icon: "return") {
                NSApp.setActivationPolicy(.accessory)
            }
            .keyboardShortcut(.return, modifiers: [])
            .padding(.bottom, 26)
            .padding(.horizontal, 26)
        }
        .frame(width: mainWindowWidth, height: mainWindowHeight)
    }
}
