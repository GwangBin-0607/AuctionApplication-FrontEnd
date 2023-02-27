//
//  DetailProductViewController+Gesture.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/27.
//

import Foundation
import UIKit
extension DetailProductViewController{
    func makePangesture()->UITapGestureRecognizer{
        UITapGestureRecognizer(target: self, action: #selector(gesture(sender:)))
    }
    @objc private func gesture(sender:UITapGestureRecognizer){
        if animator?.isRunning == true{
            self.animatorState = self.animatorState == .top ? .bottom : .top
            animator = returnAnimator()
            animator?.startAnimation()
        }else{
            animator = returnAnimator()
            animator?.startAnimation()
        }
    }
    private func returnAnimator()->UIViewPropertyAnimator{
        let returnAnimator = UIViewPropertyAnimator(duration: 3.6, dampingRatio: 0.8)
        returnAnimator.addAnimations {
            [weak self] in
            if let self = self{
                if self.animatorState == .top{
                    self.productPriceView.animateBackSubview()
                    self.heightEndConstraint.isActive = false
                    self.heightConstraint.isActive = true
                    self.backgroundView.alpha = 0.0
                }else{
                    self.productPriceView.animateSubview()
                    self.heightConstraint.isActive = false
                    self.heightEndConstraint.isActive = true
                    self.backgroundView.alpha = 0.8
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
        if pangesture.state == .began{
            if animator?.isRunning == true{
                currentFrac = animator!.fractionComplete
                print(currentFrac)
                animator?.pauseAnimation()
            }else{
                animator = returnAnimator()
                animator?.startAnimation()
                animator?.pauseAnimation()
            }
        }
        if pangesture.state == .changed{
            let ratio = animatorState == .top ? (pangesture.point.y/(self.view.frame.height*0.5)) : -(pangesture.point.y/(self.view.frame.height*0.5))
            print("RATIO ===\(ratio)       CURRENT === \(currentFrac)")
            animator?.fractionComplete = ratio+currentFrac
        }
        if pangesture.state == .ended{
            self.animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0.0)
        }
    }
    func tapGesture() {
        if animator?.isRunning == true{
            print("reverse")
            self.animatorState = self.animatorState == .top ? .bottom : .top
            animator = returnAnimator()
            animator?.startAnimation()
        }else{
            print(animatorState)
            animator = returnAnimator()
            animator?.startAnimation()
        }
    }
}
