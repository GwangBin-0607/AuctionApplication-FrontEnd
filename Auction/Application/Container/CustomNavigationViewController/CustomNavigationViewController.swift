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
    init(viewModel:Pr_CustomNavigationViewControllerViewModel) {
        containView = UIView()
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.alpha = 0.0
        bind()
    }
    override func loadView() {
        super.loadView()
        self.view = layout()
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
extension CustomNavigationViewController{
    @discardableResult
    private func constraintsBeforeViewControllerView(present:Bool)->UIView?{
        if let preView = children[children.count-2].view{
            containView.constraints.filter({$0.firstItem as? UIView == preView}).filter({$0.firstAttribute == .leading}).forEach({$0.isActive = false})
            if present{
                preView.leadingAnchor.constraint(equalTo: containView.leadingAnchor).isActive = true
            }else{
                preView.leadingAnchor.constraint(equalTo: containView.leadingAnchor, constant: animationLeading * -1).isActive = true
            }
            return preView
        }else{
            return nil
        }
    }
    private func constraintsCurrentViewControllerView(present:Bool){
        if let preView = children[children.count-1].view{
            containView.constraints.filter({$0.firstItem as? UIView == preView}).filter({$0.firstAttribute == .leading}).forEach({$0.isActive = false})
            if present{
                preView.leadingAnchor.constraint(equalTo: containView.leadingAnchor).isActive = true
            }else{
                preView.leadingAnchor.constraint(equalTo: containView.trailingAnchor).isActive = true
            }
        }
    }
}
extension CustomNavigationViewController:ContainerViewController{
    private var duration:CGFloat{
        return 0.35
    }
    private var animationLeading:CGFloat{
        return 50
    }
    func present(ViewController: UIViewController, animate: Bool) {
        if children.isEmpty{
            self.addChild(ViewController)
            containView.addSubview(ViewController.view)
            ViewController.beginAppearanceTransition(true, animated: false)
            ViewController.view.translatesAutoresizingMaskIntoConstraints = false
            ViewController.view.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
            ViewController.view.leadingAnchor.constraint(equalTo: containView.leadingAnchor).isActive = true
            ViewController.view.trailingAnchor.constraint(equalTo: containView.trailingAnchor).isActive = true
            ViewController.view.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
            ViewController.didMove(toParent: self)
            ViewController.endAppearanceTransition()
        }else{
            self.addChild(ViewController)
            ViewController.beginAppearanceTransition(true, animated: true)
            containView.addSubview(ViewController.view)
            ViewController.view.translatesAutoresizingMaskIntoConstraints = false
            ViewController.view.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
            ViewController.view.leadingAnchor.constraint(equalTo: containView.trailingAnchor).isActive = true
            ViewController.view.widthAnchor.constraint(equalTo: containView.widthAnchor).isActive = true
            ViewController.view.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
            ViewController.didMove(toParent: self)
            self.containView.layoutIfNeeded()
            let preview = constraintsBeforeViewControllerView(present: false)
            constraintsCurrentViewControllerView(present: true)
            UIView.animate(withDuration: duration,animations: {
                preview?.alpha = 0.5
                self.containView.layoutIfNeeded()
            }, completion: {
                finish in
                if finish{
                    ViewController.endAppearanceTransition()
                }
            })
        }
    }
    
    func dismiss(animate: Bool, viewController: UIViewController?) {
        let preview = constraintsBeforeViewControllerView(present: true)
        constraintsCurrentViewControllerView(present: false)
        viewController?.removeFromParent()
        viewController?.beginAppearanceTransition(false, animated: true)
        UIView.animate(withDuration: duration, delay: 0.0, animations: {
            self.containView.layoutIfNeeded()
            preview?.alpha = 1.0
        },completion: {
            finish in
            if finish{
                viewController?.view.removeFromSuperview()
                viewController?.endAppearanceTransition()
            }
        })
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
