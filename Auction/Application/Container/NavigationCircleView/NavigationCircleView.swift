//
//  NavigationCircleView.swift
//  front-end
//
//  Created by 안광빈 on 2023/02/11.
//

import UIKit
import RxSwift
class NavigationCornerRadiusView:CornerRadiusView{
    private let viewModel:Pr_NavigationCircleViewModel
    private var alphaAnimation:UIViewPropertyAnimator!
    private let disposeBag:DisposeBag
    private var viewUp:Bool
    init(ViewModel:Pr_NavigationCircleViewModel) {
        viewUp = false
        disposeBag = DisposeBag()
        self.viewModel = ViewModel
        super.init(frame: .zero, borderWidth: 2.0, borderColor: ManageColor.singleton.getMainColor())
        self.backgroundColor = ManageColor.singleton.getMainColor().withAlphaComponent(0.5)
        self.addGestureRecognizer(makePangesture())
        alphaAnimation = UIViewPropertyAnimator(duration: 0.5,curve: .linear)
        alphaAnimation.addAnimations({
            [weak self] in
            self?.backgroundColor = ManageColor.singleton.getMainColor().withAlphaComponent(1.0)
        })
        alphaAnimation.pausesOnCompletion = true
        layout()
        bind()
    }
    private func bind(){
        viewModel.loginStateObservable.withUnretained(self).subscribe(onNext: {
            owner,state in
        }).disposed(by: disposeBag)
        
        viewModel.backGestureObservable.withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.viewUp = false
            owner.animationReverser(animation: owner.alphaAnimation, reverse: true)
        }).disposed(by: disposeBag)
    }
    private func makePangesture()->UIPanGestureRecognizer{
        UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
    }
    @objc private func gesture(sender:UIPanGestureRecognizer){
        guard let superview = self.superview,!viewUp else { return }
        let translation = sender.translation(in: superview)
        let gesture = Pangesture(point: translation, state: sender.state)
        viewModel.pangestureObserver.onNext(gesture)
        sender.setTranslation(.zero, in: superview)
        if sender.state == .ended || sender.state == .failed || sender.state == .cancelled{
            animationReverser(animation: alphaAnimation, reverse: true)
        }else if sender.state == .began{
            animationReverser(animation: alphaAnimation, reverse: false)
        }
    }
    deinit {
        alphaAnimation.stopAnimation(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    private func layout(){
        
    }
}
extension NavigationCornerRadiusView{
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewUp = true
        viewModel.tapGestureObserver.onNext(())
    }
    private func animationReverser(animation:UIViewPropertyAnimator,reverse:Bool){
        animation.isReversed = reverse
        animation.startAnimation()
    }
}
