import Foundation
import UIKit
import RxSwift
final class MainContainerViewController:UIViewController{
    private let containerView:UIView
    private let navigationCircleView:NavigationCornerRadiusView
    private let viewModel:Pr_MainContainerControllerViewModel
    private let gap:CGFloat = 10
    private var navigationCircleViewTopBegin:NSLayoutConstraint!
    private var navigationCircleViewTopEnd:NSLayoutConstraint!
    private var navigationCircleViewLeadingBegin:NSLayoutConstraint!
    private var navigationCircleViewLeadingEnd:NSLayoutConstraint!
    private var navigationCircleViewWidthBegin:NSLayoutConstraint!
    private var navigationCircleViewWidthEnd:NSLayoutConstraint!
    private var navigationCircleViewHeightBegin:NSLayoutConstraint!
    private var navigationCircleViewHeightEnd:NSLayoutConstraint!
    private let disposeBag = DisposeBag()
    private let backgroundView:UIView
    weak var circleNavigationController:AlphaAnimationController?
    init(navigationCircleView:NavigationCornerRadiusView,viewModel:Pr_MainContainerControllerViewModel) {
        backgroundView = UIView()
        self.navigationCircleView = navigationCircleView
        self.viewModel = viewModel
        containerView = UIView()
        super.init(nibName: nil, bundle: nil)
        self.navigationCircleView.setDelegate(gestureDelegate: self)
        backgroundView.addGestureRecognizer(makeTapgesture())
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
        view.addSubview(navigationCircleView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        navigationCircleView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .clear
        backgroundView.alpha = 0.0
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        navigationCircleViewTopBegin = navigationCircleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0)
        navigationCircleViewTopBegin.isActive = true
        navigationCircleViewLeadingBegin = navigationCircleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gap)
        navigationCircleViewLeadingBegin.isActive = true
        navigationCircleViewHeightBegin = navigationCircleView.heightAnchor.constraint(equalTo: navigationCircleView.widthAnchor)
        navigationCircleViewHeightBegin.isActive = true
        navigationCircleViewHeightEnd = NSLayoutConstraint(item: navigationCircleView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.8, constant: 0.0)
        navigationCircleViewWidthBegin = NSLayoutConstraint(item: navigationCircleView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.2, constant: 0.0)
        navigationCircleViewWidthBegin.isActive = true
        navigationCircleViewWidthEnd = NSLayoutConstraint(item: navigationCircleView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.95, constant: 0.0)
        navigationCircleViewTopEnd = navigationCircleView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        navigationCircleViewLeadingEnd = navigationCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
}
extension MainContainerViewController:GestureDelegate{
    func pangesture(pangesture: Pangesture) {
        switch pangesture.state {
        case .changed,.began:
            let top = navigationCircleViewTopBegin.constant + pangesture.point.y
            let leading = navigationCircleViewLeadingBegin.constant + pangesture.point.x
            navigationCircleViewTopBegin.constant = maxY(top: top)
            navigationCircleViewLeadingBegin.constant = maxX(leading: leading)
        case .ended:
            animate(point: pangesture.point)
        default:
            break;
        }
    }
    func tapGesture() {
        AnimationloginView()
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
    func presentNaviationViewController(ViewController: AlphaAnimationController) {
        circleNavigationController = ViewController
        self.addChild(ViewController)
        ViewController.beginAppearanceTransition(true, animated: false)
        navigationCircleView.addSubview(ViewController.view)
        ViewController.view.translatesAutoresizingMaskIntoConstraints = false
        ViewController.view.topAnchor.constraint(equalTo: navigationCircleView.topAnchor).isActive = true
        ViewController.view.leadingAnchor.constraint(equalTo: navigationCircleView.leadingAnchor).isActive = true
        ViewController.view.trailingAnchor.constraint(equalTo: navigationCircleView.trailingAnchor).isActive = true
        ViewController.view.bottomAnchor.constraint(equalTo: navigationCircleView.bottomAnchor).isActive = true
        ViewController.didMove(toParent: self)
        ViewController.endAppearanceTransition()
    }
    private func animationBegan(){
        navigationCircleViewWidthBegin.isActive = false
        navigationCircleViewTopBegin.isActive = false
        navigationCircleViewLeadingBegin.isActive = false
        navigationCircleViewHeightBegin.isActive = false
        navigationCircleViewWidthEnd.isActive = true
        navigationCircleViewTopEnd.isActive = true
        navigationCircleViewLeadingEnd.isActive = true
        navigationCircleViewHeightEnd.isActive = true
    }
    private func animationEnd(){
        navigationCircleViewWidthEnd.isActive = false
        navigationCircleViewTopEnd.isActive = false
        navigationCircleViewLeadingEnd.isActive = false
        navigationCircleViewHeightEnd.isActive = false
        navigationCircleViewWidthBegin.isActive = true
        navigationCircleViewTopBegin.isActive = true
        navigationCircleViewLeadingBegin.isActive = true
        navigationCircleViewHeightBegin.isActive = true
    }
    
}
extension MainContainerViewController{
    var animationDuration:CGFloat{
        return 0.75
    }
    private func AnimationloginView(){
        circleNavigationController?.tapGesture(duration: animationDuration)
        self.animationBegan()
        navigationCircleView.animationWithBasicAnimation(animationDuration: animationDuration, superviewAnimationBlock: {
            self.backgroundView.backgroundColor = .black
            self.backgroundView.alpha = 0.75
            self.view.layoutIfNeeded()
        })
    }
    func makeTapgesture()->UITapGestureRecognizer{
        let tap = UITapGestureRecognizer(target: self, action: #selector(gesture(sender:)))
        tap.delaysTouchesBegan = true
        return tap
    }
    @objc private func gesture(sender:UITapGestureRecognizer){
        circleNavigationController?.backGesture(duration: animationDuration)
        self.animationEnd()
        navigationCircleView.animationReverse(animationDuration: animationDuration, superviewAnimationBlock: {
            self.backgroundView.backgroundColor = .clear
            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }

}
extension MainContainerViewController{
    private func maxX(leading:CGFloat)->CGFloat{
        return min(self.view.frame.maxX-gap-self.navigationCircleView.frame.width, max(leading,gap))
    }
    private func maxY(top:CGFloat)->CGFloat{
        let safeAreaTopBottom = self.view.safeAreaInsets.bottom+self.view.safeAreaInsets.top
        let bottomMaxY = self.view.frame.height-safeAreaTopBottom-self.navigationCircleView.frame.height
        return min(bottomMaxY, max(top,0.0))
    }
    private func animate(point:CGPoint){
        let center = self.navigationCircleViewLeadingBegin.constant+self.navigationCircleView.frame.width/2
        if center <= self.view.center.x{
            self.navigationCircleViewLeadingBegin.constant = gap
        }else{
            self.navigationCircleViewLeadingBegin.constant = self.view.frame.maxX - self.navigationCircleView.frame.width-gap
        }
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75,options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
