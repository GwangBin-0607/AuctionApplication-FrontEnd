import Foundation
import UIKit
import RxSwift
final class MainContainerViewController:UIViewController{
    private let containerView:ContainerView
    private let viewModel:Pr_MainContainerControllerViewModel
    private let disposeBag = DisposeBag()
    private var animator:UIViewPropertyAnimator?
    private let button:UIButton
    init(viewModel:Pr_MainContainerControllerViewModel) {
        self.viewModel = viewModel
        button = UIButton()
        containerView = ContainerView()
        super.init(nibName: nil, bundle: nil)
        containerView.setDelegate(gesture: self)
        animator = animator(duration: 1.0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        self.view = layout()
    }
    private var leading:NSLayoutConstraint?
    private var trailing:NSLayoutConstraint?
    private var top:NSLayoutConstraint?
    private var bottom:NSLayoutConstraint?
    private func layout()->UIView{
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.backgroundColor = .systemYellow
        containerView.translatesAutoresizingMaskIntoConstraints = false
        top = containerView.topAnchor.constraint(equalTo: button.bottomAnchor)
        top?.isActive = true
        leading = containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        leading?.isActive = true
        trailing = containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        trailing?.isActive = true
        bottom = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottom?.isActive = true
        return view
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    private func bind(){

    }
}
extension MainContainerViewController:GestureDelegate{
    func pangesture(pangesture: Pangesture) {
        animator?.pauseAnimation()
        animator?.fractionComplete += pangesture.point.x/200
    }
    func tapGesture() {
        print("Tap")
    }
}
extension MainContainerViewController{
    private func animator(duration:CGFloat)->UIViewPropertyAnimator{
        let animator = UIViewPropertyAnimator(duration: duration,curve: .easeInOut)
        animator.pausesOnCompletion = true
        animator.addAnimations {
            self.bottom?.constant = 100
            self.trailing?.constant = 200
            self.top?.constant = 100
            self.leading?.constant = 200
            self.view.layoutIfNeeded()
        }
        
        return animator
    }
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
    
}
final class ContainerView:UIView{
    weak var delegate:GestureDelegate?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addGestureRecognizer(makePangesture())
        setShadow()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(rect: CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: self.frame.height))).cgPath

    }
    private func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setDelegate(gesture:GestureDelegate){
        self.delegate = gesture
    }
    private func makePangesture()->UIPanGestureRecognizer{
        let pan = UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
        pan.delegate = self
        return pan
    }
    @objc private func gesture(sender:UIPanGestureRecognizer){
        let translation = sender.translation(in: self)
        let gesture = Pangesture(point: translation, state: sender.state)
        delegate?.pangesture(pangesture: gesture)
        sender.setTranslation(.zero, in: self)

    }
    
}
extension ContainerView:UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(self.frame)
        print(gestureRecognizer.location(in: self))
        return true
    }
}
