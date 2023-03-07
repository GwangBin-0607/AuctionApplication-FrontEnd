//
//  DetailProductViewController+Gesture.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/27.
//

import Foundation
import UIKit
import RxSwift
extension DetailProductViewController{
    enum AnimatorState{
        case top
        case bottom
    }
    func makeTapgesture()->UITapGestureRecognizer{
        let tap = UITapGestureRecognizer(target: self, action: #selector(gesture(sender:)))
        tap.delaysTouchesBegan = true
        return tap
    }
    private var duration:CGFloat{
        return 0.65
    }
    @objc private func gesture(sender:UITapGestureRecognizer){
        
//        if animator?.isRunning == true{
//            self.animatorState = self.animatorState == .top ? .bottom : .top
//            startAnimation()
//        }else if animatorState == .top{
//            startAnimation()
//        }
    }
    func returnAnimator()->UIViewPropertyAnimator{
        let returnAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.85)
        returnAnimator.addAnimations {
            [weak self] in
            self?.heightConstraint.isActive = false
            self?.productPriceView.animateSubview()
            self?.heightEndConstraint.isActive = true
                self?.view.layoutIfNeeded()
        }
        returnAnimator.pausesOnCompletion = true
        returnAnimator.addObserver(self, forKeyPath: #keyPath(UIViewPropertyAnimator.isRunning),options: [.new], context: nil)
        return returnAnimator
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UIViewPropertyAnimator.isRunning){
            if animator.fractionComplete >= 0.9 {
                animatorState = animator.isReversed ? .bottom : .top
                animator.isReversed = !animator.isReversed
            }
        }

    }
}
extension DetailProductViewController:GestureDelegateWithButton{
    func tapGesture() {
        if animator.isRunning{
            animator.isReversed = animatorState == .bottom ? true : false
            animatorState = animatorState == .top ? .bottom : .top
        }
        if !animator.isRunning{
            animator.startAnimation()
        }
    }
    func pangesture(pangesture: Pangesture) {
        switch pangesture.state{
        case .began:
            animator.pauseAnimation()
        case .changed:
            let ratio = animatorState == .bottom ? -(pangesture.point.y/(view.frame.height*0.4)) : (pangesture.point.y/(view.frame.height*0.4))
            let max = max(ratio, 0.0)
            animator.fractionComplete = min(max,1.0)
        case .ended:
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.0)
        default:
            break;

        }
    }
    func buttonTap() {
        if animatorState == .bottom{
            animator.startAnimation()
        }else{
            viewModel.buyProduct.onNext(())
        }
    }
}
