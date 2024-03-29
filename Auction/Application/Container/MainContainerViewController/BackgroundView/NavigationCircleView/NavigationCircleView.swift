//
//  NavigationCircleView.swift
//  front-end
//
//  Created by 안광빈 on 2023/02/11.
//

import UIKit
import RxSwift
protocol GestureDelegate:AnyObject {
    func pangesture(pangesture:Pangesture)
    func tapGesture()
}
class NavigationCornerRadiusView:CornerRadiusView{
    private let viewModel:Pr_NavigationCircleViewModel
    private var alphaAnimation:UIViewPropertyAnimator!
    private let disposeBag:DisposeBag
    private var viewUp:Bool
    private var previousRadius:CGFloat = 0.0
    weak var gestureDelegate:GestureDelegate?
    private let userImageView:UIImageView
    weak var contentView:UIView?
    init(ViewModel:Pr_NavigationCircleViewModel) {
        userImageView = UIImageView()
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
    func addView(view:UIView){
        
        self.contentView = view
    }
    private func animateContentView(){
        if let view = self.contentView{
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            view.alpha = 0.0
        }
    }
    private func removeContentView(){
        self.contentView?.removeFromSuperview()
    }
    func setDelegate(gestureDelegate:GestureDelegate){
        self.gestureDelegate = gestureDelegate
    }
    private func bind(){
        let image = UIImage(named: "user")?.withTintColor(.white)
        self.userImageView.image = image
    }
    private func makePangesture()->UIPanGestureRecognizer{
        UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
    }
    @objc private func gesture(sender:UIPanGestureRecognizer){
        guard let superview = self.superview,!viewUp else { return }
        let translation = sender.translation(in: superview)
        let gesture = Pangesture(point: translation, state: sender.state)
        gestureDelegate?.pangesture(pangesture: gesture)
        sender.setTranslation(.zero, in: superview)
        if sender.state == .ended || sender.state == .failed || sender.state == .cancelled{
            animationReverser(animation: alphaAnimation, reverse: true)
        }else if sender.state == .began{
            animationReverser(animation: alphaAnimation, reverse: false)
        }
    }
    private func backGesture(){
        animationReverser(animation: alphaAnimation, reverse: true)
    }
    deinit {
        alphaAnimation.stopAnimation(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    private func layout(){
        self.addSubview(userImageView)
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: userImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor).isActive = true
        userImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    override func layoutSubviews() {
        if !viewUp{
            super.layoutSubviews()
        }
    }
}
extension NavigationCornerRadiusView{
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureDelegate?.tapGesture()
    }
    private func animationReverser(animation:UIViewPropertyAnimator,reverse:Bool){
        animation.isReversed = reverse
        animation.startAnimation()
    }
}
extension NavigationCornerRadiusView{
    private var contentAlphaDuration:CGFloat{
        return 0.3
    }
    func animationWithBasicAnimation(animationDuration:CGFloat,superviewAnimationBlock:@escaping()->Void,completion:(()->Void)?){
        if !viewUp{
            viewUp = true
            previousRadius = self.layer.cornerRadius
            UIView.animate(withDuration: animationDuration,delay: 0.0,usingSpringWithDamping: 0.9,initialSpringVelocity: 0.9,animations: {
                self.userImageView.alpha = 0.0
                self.contentView!.alpha = 1.0
                self.layer.cornerRadius = 20
                self.backgroundColor = .darkGray.withAlphaComponent(0.5)
                self.layer.borderColor = UIColor.darkGray.cgColor
                superviewAnimationBlock()
            },completion: {
                finish in
                if finish{
                    self.animateContentView()
                    UIView.animate(withDuration: self.contentAlphaDuration, delay: 0.0, animations: {
                        self.contentView?.alpha = 1.0
                    },completion: {
                        secondFinish in
                        if secondFinish{
                            completion?()
                        }
                    })
                }
            })
        }
    }
    func animationReverse(animationDuration:CGFloat,superviewAnimationBlock:@escaping()->Void,completion:(()->Void)?){
        if viewUp{
            viewUp = false
            UIView.animate(withDuration: self.contentAlphaDuration, delay: 0.0, animations: {
                self.contentView?.alpha = 0.0
            },completion: {
                finish in
                if finish{
                    self.removeContentView()
                    UIView.animate(withDuration: animationDuration,delay: 0.0,usingSpringWithDamping: 0.9,initialSpringVelocity: 0.9,animations: {
                        self.userImageView.alpha = 1.0
                        self.contentView!.alpha = 0.0
                        self.layer.cornerRadius = self.previousRadius
                        self.backgroundColor = ManageColor.singleton.getMainColor().withAlphaComponent(0.5)
                        self.layer.borderColor = ManageColor.singleton.getMainColor().cgColor
                        superviewAnimationBlock()
                    },completion:  {
                        secondfinish in
                        if secondfinish{
                            completion?()
                        }
                    })
                }
            })
        }
    }

}
