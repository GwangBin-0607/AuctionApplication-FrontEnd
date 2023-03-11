import Foundation
import UIKit
import RxSwift
final class MainContainerViewController:UIViewController{
    private let containerView:UIView
    private let viewModel:Pr_MainContainerControllerViewModel
    private let disposeBag = DisposeBag()
    private let backgroundView:BackgroundView
    init(viewModel:Pr_MainContainerControllerViewModel,backgroundView:BackgroundView) {
        self.backgroundView = backgroundView
        self.viewModel = viewModel
        containerView = UIView()
        super.init(nibName: nil, bundle: nil)
        createDisplayLink()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        self.view = layout()
    }
    private func layout()->UIView{
        let view = UIView()
        view.backgroundColor = .red
        view.addSubview(containerView)
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo:  view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    private func bind(){

    }
    var preTime:TimeInterval?
}
extension MainContainerViewController:ContainerViewController{
    func dismiss(animate: Bool,viewController:UIViewController?) {
        viewController?.removeFromParent()
        viewController?.view.removeFromSuperview()
    }
    func present(ViewController: Pr_ChildViewController, animate: Bool) {
        self.addChild(ViewController)
        ViewController.beginAppearanceTransition(true, animated: true)
        self.containerView.addSubview(ViewController.view)
        ViewController.view.translatesAutoresizingMaskIntoConstraints = false
        ViewController.view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        ViewController.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        ViewController.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        ViewController.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        ViewController.view.alpha = 0.0
        ViewController.completion = {
            [weak ViewController] in
            UIView.animate(withDuration: 1.0, delay: .zero, options: .curveLinear, animations: {
                ViewController?.view.alpha = 1.0
            }, completion: {
                finish in
                ViewController?.didMove(toParent: self)
                ViewController?.endAppearanceTransition()
            })
        }
    }
    func present(ViewController: UIViewController, animate: Bool) {
        self.addChild(ViewController)
        ViewController.beginAppearanceTransition(true, animated: true)
        containerView.addSubview(ViewController.view)
        ViewController.view.translatesAutoresizingMaskIntoConstraints = false
        ViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        ViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        ViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        ViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        ViewController.didMove(toParent: self)
        ViewController.endAppearanceTransition()
    }
    func presentNaviationViewController(ViewController: UIViewController) {
        self.addChild(ViewController)
        ViewController.beginAppearanceTransition(true, animated: false)
        backgroundView.addView(view: ViewController.view)
        ViewController.didMove(toParent: self)
        ViewController.endAppearanceTransition()
    }
    
}
extension MainContainerViewController{
    func createDisplayLink() {
        let displaylink = CADisplayLink(target: self,
                                        selector: #selector(step))
        
        displaylink.add(to: .current,
                        forMode: .default)
    }
    @objc func step(displaylink: CADisplayLink) {
        if let preTime = preTime{
            if (displaylink.timestamp - preTime) >= 0.017{
                print(displaylink.timestamp - preTime)
            }
        }
        self.preTime = displaylink.timestamp
    }
}
