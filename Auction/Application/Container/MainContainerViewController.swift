import Foundation
import UIKit
import RxSwift
final class MainContainerViewController:UIViewController{
    private let containerView:UIView
    private let navigationCircleView:NavigationCornerRadiusView
    private let viewModel:Pr_MainContainerControllerViewModel
    private let gap:CGFloat = 10
    private var navigationCircleViewTop:NSLayoutConstraint!
    private var navigationCircleViewLeading:NSLayoutConstraint!
    private let disposeBag = DisposeBag()
    init(navigationCircleView:NavigationCornerRadiusView,viewModel:Pr_MainContainerControllerViewModel) {
        self.navigationCircleView = navigationCircleView
        self.viewModel = viewModel
        containerView = UIView()
        super.init(nibName: nil, bundle: nil)
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
        view.addSubview(navigationCircleView)
        navigationCircleView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        navigationCircleViewTop = navigationCircleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0)
        navigationCircleViewTop.isActive = true
        navigationCircleViewLeading = navigationCircleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gap)
        navigationCircleViewLeading.isActive = true
        navigationCircleView.heightAnchor.constraint(equalTo: navigationCircleView.widthAnchor).isActive = true
        NSLayoutConstraint(item: navigationCircleView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.25, constant: 0.0).isActive = true
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
        viewModel.pangestureObservable.withUnretained(self).subscribe(onNext: {
            owner,pangesture in
            switch pangesture.state {
            case .changed,.began:
                let top = owner.navigationCircleViewTop.constant + pangesture.point.y
                let leading = owner.navigationCircleViewLeading.constant + pangesture.point.x
                owner.navigationCircleViewTop.constant = owner.maxY(top: top)
                owner.navigationCircleViewLeading.constant = owner.maxX(leading: leading)
            case .ended:
                owner.animate(point: pangesture.point)
            default:
                break;
            }
        }).disposed(by: disposeBag)
        viewModel.tapgestureObservable.withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.viewModel.presentUserPage.onNext(())
        }).disposed(by: disposeBag)
    }
}
extension MainContainerViewController:ContainerViewController{
    func dismiss(animate: Bool) {
        self.children.last?.view.removeFromSuperview()
        self.children.last?.removeFromParent()
    }
    func present(ViewController: Pr_ChildViewController, animate: Bool) {
        self.addChild(ViewController)
        ViewController.view.frame = CGRect(x: self.containerView.frame.maxX, y: self.containerView.frame.minX, width:self.containerView.frame.width, height: self.containerView.frame.height)
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
    let last = children.last
    self.addChild(ViewController)
    if last == nil{
        containerView.addSubview(ViewController.view)
        ViewController.beginAppearanceTransition(true, animated: true)
        ViewController.view.translatesAutoresizingMaskIntoConstraints = false
        ViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        ViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        ViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        ViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        ViewController.didMove(toParent: self)
        ViewController.endAppearanceTransition()
    }
}
    func presentUserPage(ViewController: UIViewController) {
        self.addChild(ViewController)
        ViewController.beginAppearanceTransition(true, animated: true)
        self.view.addSubview(ViewController.view)
        ViewController.view.translatesAutoresizingMaskIntoConstraints = false
        ViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        ViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        ViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        ViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        ViewController.endAppearanceTransition()
        ViewController.didMove(toParent: self)
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
        let center = self.navigationCircleViewLeading.constant+self.navigationCircleView.frame.width/2
        if center <= self.view.center.x{
            self.navigationCircleViewLeading.constant = gap
        }else{
            self.navigationCircleViewLeading.constant = self.view.frame.maxX - self.navigationCircleView.frame.width-gap
        }
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75,options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
