import UIKit

extension UIView {
    func setShadow(color: UIColor = .black,
                   opacity: Float = 0.1,
                   offset: CGSize = CGSize(width: 0, height: 4),
                   radius: CGFloat = 8.0
        ){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }

    func feedIn(visible condition: Bool) {
        self.transform.ty = 20
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.isHidden = condition
            self?.transform = .identity
        }
    }
}
