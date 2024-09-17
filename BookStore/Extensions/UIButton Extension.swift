import UIKit
import SnapKit

extension UIButton {
    static func makeButton(text: String, buttonColor: UIColor, tintColor: UIColor, borderWidth: CGFloat) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: .normal)
        button.backgroundColor = buttonColor
        button.setTitleColor(tintColor, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.openSansRegular(ofSize: 14)
        button.layer.borderWidth = borderWidth
        return button
    }
}

extension UIButton {
    struct Trigger { static var action :(() -> Void)? }
    private func actionHandler(action:(() -> Void)? = nil) {
        if action != nil {
            Trigger.action = action
        } else {
            Trigger.action?()
        }
    }
    @objc private func triggerActionHandler() {
        self.actionHandler()
    }
    func actionHandler(controlEvents control: UIControl.Event, for action: @escaping () -> Void) {
        self.actionHandler(action: action)
        self.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
}
