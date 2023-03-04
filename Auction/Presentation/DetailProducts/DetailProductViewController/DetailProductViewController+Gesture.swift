//
//  DetailProductViewController+Gesture.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/27.
//

import Foundation
import UIKit
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
            self?.viewModel.priceViewAnimationSubview.onNext(())
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
