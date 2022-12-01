import Foundation
import UIKit
final class MainContainerViewController:UIViewController{
    private let containerView:UIView
    init() {
        containerView = UIView()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        let view = UIView()
        view.backgroundColor = .red
        view.addSubview(containerView)
        containerView.backgroundColor = .yellow
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.view = view
    }
}
extension MainContainerViewController:TransitioningViewController{
    func dismiss(animate: Bool) {
        self.children.last?.view.removeFromSuperview()
        self.children.last?.removeFromParent()
    }
    func present(ViewController: UIViewController?, animate: Bool) {
        guard let ViewController = ViewController else{
            return
        }
        let last = children.last
        self.addChild(ViewController)
        if last == nil{
            containerView.addSubview(ViewController.view)
            ViewController.view.translatesAutoresizingMaskIntoConstraints = false
            ViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            ViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            ViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            ViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            ViewController.didMove(toParent: self)
        }else{
            ViewController.view.frame = CGRect(x: containerView.frame.maxX, y: containerView.frame.minX, width: containerView.frame.width, height: containerView.frame.height)
            ViewController.beginAppearanceTransition(true, animated: true)
            containerView.addSubview(ViewController.view)
            ViewController.view.translatesAutoresizingMaskIntoConstraints = false
            ViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            ViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            ViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            ViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            ViewController.view.alpha = 0.0
            UIView.animate(withDuration: 1.0, delay: .zero, options: .curveLinear, animations: {
                ViewController.view.alpha = 1.0
            }, completion: {
                finish in
                ViewController.endAppearanceTransition()
            })

        }
    }
}
