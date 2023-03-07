//
//  CustomNavigationViewController.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/07.
//

import Foundation
import UIKit
import RxSwift
final class CustomNavigationViewController:UIViewController{
    private let viewModel:Pr_CustomNavigationViewControllerViewModel
    private let disposeBag:DisposeBag
    private let containView:UIView
    init(viewModel:Pr_CustomNavigationViewControllerViewModel,rootViewController:UIViewController) {
        containView = UIView()
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.alpha = 0.0
        bind()
        layoutrootViewController(rootViewController: rootViewController)
    }
    override func loadView() {
        super.loadView()
        self.view = layout()
    }
    private func layoutrootViewController(rootViewController:UIViewController){
        self.addChild(rootViewController)
        containView.addSubview(rootViewController.view)
        rootViewController.beginAppearanceTransition(true, animated: true)
        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false
        rootViewController.view.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        rootViewController.view.leadingAnchor.constraint(equalTo: containView.leadingAnchor).isActive = true
        rootViewController.view.trailingAnchor.constraint(equalTo: containView.trailingAnchor).isActive = true
        rootViewController.view.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
        rootViewController.didMove(toParent: self)
        rootViewController.endAppearanceTransition()
    }
    private func bind(){
        
    }
    private func layout()->UIView{
        let view = UIView()
        view.addSubview(containView)
        containView.translatesAutoresizingMaskIntoConstraints = false
        containView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CustomNavigationViewController:ContainerViewController{
    func present(ViewController: UIViewController, animate: Bool) {
        self.addChild(ViewController)
        containView.addSubview(ViewController.view)
        ViewController.beginAppearanceTransition(true, animated: true)
        ViewController.view.translatesAutoresizingMaskIntoConstraints = false
        ViewController.view.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        ViewController.view.leadingAnchor.constraint(equalTo: containView.leadingAnchor).isActive = true
        ViewController.view.trailingAnchor.constraint(equalTo: containView.trailingAnchor).isActive = true
        ViewController.view.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
        ViewController.didMove(toParent: self)
        ViewController.endAppearanceTransition()
    }
    
    func dismiss(animate: Bool, viewController: UIViewController?) {
    }
}
extension CustomNavigationViewController:AlphaAnimationController{
    func tapGesture(){
        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
            self.view.alpha = 1.0
        })
    }
    func backGesture(){
        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
            self.view.alpha = 0.0
        })
    }
}
