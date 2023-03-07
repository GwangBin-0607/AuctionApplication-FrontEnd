//
//  UserPageViewController.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation
import UIKit
import RxSwift
final class UserPageViewController:UIViewController{
    
    private let viewModel:Pr_UserPageViewControllerViewModel
    private let disposeBag:DisposeBag
    private let mockButton:UIButton
    init(viewModel:Pr_UserPageViewControllerViewModel,transtioning:TransitionUserPageViewController) {
        mockButton = UIButton()
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        self.viewModel.setTransitioning(delegate: transtioning)
    }
    override func loadView() {
        super.loadView()
        self.view = layout()
    }
    private func bind(){
    }
    private func layout()->UIView{
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(mockButton)
        mockButton.frame = CGRect(x: 50, y: 50, width:100, height: 100)
        mockButton.backgroundColor = .yellow
        mockButton.rx.tap.bind(to: viewModel.mock)
        return view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
final class CustomNavigation:UINavigationController{
    let viewModel:Pr_CustomNavigationViewModel
    private let disposeBag:DisposeBag
    init(viewModel:Pr_CustomNavigationViewModel,rootViewController:UIViewController) {
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(rootViewController: rootViewController)
        self.view.alpha = 0.0
        self.interactivePopGestureRecognizer?.delegate = self
        bind()
    }
    private func bind(){
        viewModel.tapGestureObservable.withUnretained(self).subscribe(onNext: {
            owner,_ in
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                owner.view.alpha = 1.0
            })
        }).disposed(by: disposeBag)
        viewModel.backGestureObservable.withUnretained(self).subscribe(onNext: {
            owner,_ in
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                owner.view.alpha = 0.0
            })
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CustomNavigation:ContainerViewController{
    func present(ViewController: UIViewController, animate: Bool) {
        self.pushViewController(ViewController, animated: true)
    }
    
    func dismiss(animate: Bool, viewController: UIViewController?) {
        self.popViewController(animated: animate)
    }
}
extension CustomNavigation:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(gestureRecognizer)
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print(gestureRecognizer)
        return true
    }
}
protocol Pr_CustomNavigationViewModel:Pr_NavigationContentViewModel{
}
final class CustomNavigationViewModel:Pr_CustomNavigationViewModel{
    let tapGestureObserver: AnyObserver<Void>
    let tapGestureObservable: Observable<Void>
    let backGestureObserver: AnyObserver<Void>
    let backGestureObservable: Observable<Void>
    init() {
        let backGestureSubject = PublishSubject<Void>()
        backGestureObservable = backGestureSubject.asObservable()
        backGestureObserver = backGestureSubject.asObserver()
        let tapGestureSubject = PublishSubject<Void>()
        tapGestureObserver = tapGestureSubject.asObserver()
        tapGestureObservable = tapGestureSubject.asObservable()
    }
}
