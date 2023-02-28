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
        return 0.5
    }
    @objc private func gesture(sender:UITapGestureRecognizer){
        
        if animator?.isRunning == true{
            self.animatorState = self.animatorState == .top ? .bottom : .top
            startAnimation()
        }else if animatorState == .top{
            startAnimation()
        }
    }
    private func returnAnimator()->UIViewPropertyAnimator{
        let returnAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.85)
        returnAnimator.addAnimations {
            [weak self] in
            if let self = self{
                if self.animatorState == .top{
                    self.productPriceView.animateBackSubview()
                    self.heightEndConstraint.isActive = false
                    self.heightConstraint.isActive = true
                }else{
                    self.productPriceView.animateSubview()
                    self.heightConstraint.isActive = false
                    self.heightEndConstraint.isActive = true
                }
                self.view.layoutIfNeeded()
            }
        }
        returnAnimator.isUserInteractionEnabled = true
        returnAnimator.addCompletion({
            [weak self] state in
            if self?.animator == returnAnimator{
                print("Completion")
                switch state {
                case .end:
                    self?.animatorState = self?.animatorState == .top ? .bottom : .top
                default:
                    break;
                }
            }
        })
        return returnAnimator
    }
}
extension DetailProductViewController:GestureDelegate{
    func gesture(pangesture: Pangesture) {
        switch pangesture.state{
        case .began:
            startAnimation()
            animator?.pauseAnimation()
        case .changed:
            let ratio = animatorState == .top ? (pangesture.point.y/(self.view.frame.height*0.5)) : -(pangesture.point.y/(self.view.frame.height*0.5))
            animator?.fractionComplete = min(ratio,1.0)
        case .ended,.cancelled,.failed:
            self.animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0.0)
        default:
            break;

        }
    }
    func tapGesture() {
        if animator?.isRunning == true{
            self.animatorState = self.animatorState == .top ? .bottom : .top
        }
        startAnimation()
    }
    func startAnimation(){
        print("START!")
        animator = returnAnimator()
        animator?.startAnimation()
    }
}
