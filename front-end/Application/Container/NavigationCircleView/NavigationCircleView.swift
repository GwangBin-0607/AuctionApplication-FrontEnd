//
//  NavigationCircleView.swift
//  front-end
//
//  Created by 안광빈 on 2023/02/11.
//

import UIKit
class NavigationCornerRadiusView:CornerRadiusView{
    
    let viewModel:Pr_NavigationCircleViewModel
    private var alphaAnimation:UIViewPropertyAnimator!
    init(setBackgroundColor:UIColor,ViewModel:Pr_NavigationCircleViewModel,borderWidth:CGFloat,borderColor:UIColor) {
        self.viewModel = ViewModel
        super.init(frame: .zero, borderWidth: borderWidth, borderColor: borderColor)
        self.backgroundColor = setBackgroundColor.withAlphaComponent(0.5)
        self.addGestureRecognizer(makePangesture())
        alphaAnimation = UIViewPropertyAnimator(duration: 1.0,curve: .linear)
        alphaAnimation.addAnimations({
            [weak self] in
            self?.backgroundColor = setBackgroundColor.withAlphaComponent(1.0)
        })
        alphaAnimation.pausesOnCompletion = true
    }
    private func makePangesture()->UIPanGestureRecognizer{
        UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
    }
    @objc private func gesture(sender:UIPanGestureRecognizer){
        guard let superview = self.superview else { return }
        let translation = sender.translation(in: superview)
        let gesture = Pangesture(point: translation, state: sender.state)
        viewModel.gestureObserver.onNext(gesture)
        sender.setTranslation(.zero, in: superview)
        if sender.state == .ended || sender.state == .failed || sender.state == .cancelled{
            animationReverser(animation: alphaAnimation, reverse: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
extension NavigationCornerRadiusView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TOUCH")
        animationReverser(animation: self.alphaAnimation, reverse: false)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("END")
        animationReverser(animation: self.alphaAnimation, reverse: true)
        viewModel.menuClickObserver.onNext(())
    }
    private func animationReverser(animation:UIViewPropertyAnimator,reverse:Bool){
        animation.isReversed = reverse
        if animation.fractionComplete == 0.0 || animation.fractionComplete == 1.0{
            animation.startAnimation()
        }
    }
}
