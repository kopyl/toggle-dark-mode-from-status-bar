import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    enum StyleType {
        case primary, secondary
    }
    
    let type: StyleType
    let foregroundColor: Color
    let backgroundColor: Color
    let pressedColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .font(.system(size: 14, weight: .regular))
            .padding(12)
            .padding(.leading, 10)
            .foregroundColor(foregroundColor)
            .background(configuration.isPressed ? pressedColor : backgroundColor)
            .cornerRadius(7)
    }

    static var primary: CustomButtonStyle {
        CustomButtonStyle(
            type: .primary,
            foregroundColor: .primaryText,
            backgroundColor: .buttonBg,
            pressedColor: .black.opacity(0.05)
        )
    }
}

struct ButtonIcon: View {
    let icon: String
    let style: CustomButtonStyle

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 12, weight: .medium ))
            .foregroundColor(style.foregroundColor)
            .frame(width: 33, height: 25)
            .cornerRadius(4)
    }
}

struct StyledButton: View {
    var style: CustomButtonStyle
    var title: String
    var icon: String
    var action: () -> Void

    init(
        _ style: CustomButtonStyle,
        _ title: String,
        icon: String,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                ButtonIcon(icon: icon, style: style)
            }
        }
        .buttonStyle(style)
    }
}
