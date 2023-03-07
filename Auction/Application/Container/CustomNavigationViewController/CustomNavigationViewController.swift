//
//  CustomNavigationViewController.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/07.
//

import Foundation
import UIKit
import RxSwift
final class CustomNavigation:UINavigationController{
    let viewModel:Pr_CustomNavigationViewModel
    private let disposeBag:DisposeBag
    init(viewModel:Pr_CustomNavigationViewModel,rootViewController:UIViewController) {
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(rootViewController: rootViewController)
        self.view.alpha = 0.0
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
