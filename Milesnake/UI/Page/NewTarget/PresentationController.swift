import UIKit

enum PresentationOperation {
    case present
    case dismiss
}

final class PresentationController: UIPresentationController {
    var overlay: UIView?

    init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }

    override func presentationTransitionWillBegin() {
        let containerView = self.containerView!

        overlay = UIView(frame: containerView.bounds)
        guard let overlay = overlay else { return }
        overlay.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(overlayDidTouch(sender:)))]
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.5
        containerView.insertSubview(overlay, at: 0)

        // トランジションを実行
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {
            [weak self] context in
            self?.overlay?.alpha = 0.5
            }, completion: nil)
    }

    // 非表示トランジション開始後に呼ばれる
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.overlay?.removeFromSuperview()
        }
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width / 2, height: parentSize.height)
    }

    // レイアウト開始後に呼ばれる
    override func containerViewDidLayoutSubviews() {
    }

    @objc private func overlayDidTouch(sender: AnyObject) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

extension PresentationController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationTransitionController()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransitionController()
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor
    }
}

let interactor = Interactor()


final class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

final class DismissTransitionController: NSObject, UIViewControllerAnimatedTransitioning {


    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }

        let containerView = transitionContext.containerView

        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)

        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromVC.view.frame = finalFrame
        },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        )
    }
}

final class PresentationTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }

        let containerView = transitionContext.containerView

        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)

        toVC.view.transform.ty = toVC.view.frame.height
        containerView.addSubview(toVC.view)
        toVC.view.alpha = 0.0
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseOut,
            animations: {
                toVC.view.transform = .identity
                toVC.view.alpha = 1.0
                toVC.view.layer.cornerRadius = 30
        },
            completion: { _ in
                transitionContext.completeTransition(true)
        }
        )
    }
}



