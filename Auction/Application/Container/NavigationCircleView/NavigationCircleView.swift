//
//  NavigationCircleView.swift
//  front-end
//
//  Created by 안광빈 on 2023/02/11.
//

import UIKit
class NavigationCornerRadiusView:CornerRadiusView{
    
    private let viewModel:Pr_NavigationCircleViewModel
    private var alphaAnimation:UIViewPropertyAnimator!
    private let profileImageView:ProfileImageView
    private let nicknameLabel:UILabel
    init(ViewModel:Pr_NavigationCircleViewModel) {
        profileImageView = ProfileImageView()
        nicknameLabel = UILabel()
        self.viewModel = ViewModel
        super.init(frame: .zero, borderWidth: 2.0, borderColor: ManageColor.singleton.getMainColor())
        self.backgroundColor = ManageColor.singleton.getMainColor().withAlphaComponent(0.5)
        self.addGestureRecognizer(makePangesture())
        alphaAnimation = UIViewPropertyAnimator(duration: 1.0,curve: .linear)
        alphaAnimation.addAnimations({
            [weak self] in
            self?.backgroundColor = ManageColor.singleton.getMainColor().withAlphaComponent(1.0)
        })
        alphaAnimation.pausesOnCompletion = true
        layout()
    }
    private func makePangesture()->UIPanGestureRecognizer{
        UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
    }
    @objc private func gesture(sender:UIPanGestureRecognizer){
        guard let superview = self.superview else { return }
        let translation = sender.translation(in: superview)
        let gesture = Pangesture(point: translation, state: sender.state)
        viewModel.pangestureObserver.onNext(gesture)
        sender.setTranslation(.zero, in: superview)
        if sender.state == .ended || sender.state == .failed || sender.state == .cancelled{
            animationReverser(animation: alphaAnimation, reverse: true)
        }
    }
    deinit {
        alphaAnimation.stopAnimation(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    private func layout(){
        self.addSubview(nicknameLabel)
        self.addSubview(profileImageView)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.6, constant: 0.0).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: profileImageView, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        nicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5.0).isActive = true
        nicknameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0).isActive = true
        nicknameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5.0).isActive = true
        nicknameLabel.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        nicknameLabel.textAlignment = .center
        
//        profileImageView.backgroundColor = .blue
//        nicknameLabel.backgroundColor = .yellow
//        nicknameLabel.text = "!!!!!"
    }
}
extension NavigationCornerRadiusView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animationReverser(animation: self.alphaAnimation, reverse: false)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animationReverser(animation: self.alphaAnimation, reverse: true)
        viewModel.tapGestureObserver.onNext(())
    }
    private func animationReverser(animation:UIViewPropertyAnimator,reverse:Bool){
        animation.isReversed = reverse
        animation.startAnimation()
    }
}
