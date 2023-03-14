//
//  BackgroundView.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/11.
//

import Foundation
import UIKit
import RxSwift
class BackgroundView:UIView{
    let navigationView:NavigationCornerRadiusView
    private var navigationCircleViewTopBegin:NSLayoutConstraint!
    private var navigationCircleViewTopEnd:NSLayoutConstraint!
    private var navigationCircleViewLeadingBegin:NSLayoutConstraint!
    private var navigationCircleViewLeadingEnd:NSLayoutConstraint!
    private var navigationCircleViewWidthBegin:NSLayoutConstraint!
    private var navigationCircleViewWidthEnd:NSLayoutConstraint!
    private var navigationCircleViewHeightBegin:NSLayoutConstraint!
    private var navigationCircleViewHeightEnd:NSLayoutConstraint!
    private var closeButtonTopEnd:NSLayoutConstraint!
    private var closeButtomTopStart:NSLayoutConstraint!
    private let gap:CGFloat = 10
    private let viewModel:Pr_BackgroundViewModel
    private var appearCompletion:(()->Void)?
    private var disappearCompletion:(()->Void)?
    private var endCompletion:(()->Void)?
    private let closeButton:CustomTextButton
    private let disposeBag:DisposeBag
    init(navigationView:NavigationCornerRadiusView,viewModel:Pr_BackgroundViewModel) {
        disposeBag = DisposeBag()
        closeButton = CustomTextButton()
        isUp = false
        self.navigationView = navigationView
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.navigationView.setDelegate(gestureDelegate: self)
        layout()
        self.backgroundColor = .clear
        self.alpha = 1.0
        closeButton.setTitleColor(.darkGray, for: .normal)
        closeButton.tintColor = .black
        closeButton.backgroundColor = .white
        closeButton.setTitle("닫 기", for: .normal)
        bind()
    }
    func addView(view:UIView){
        
        navigationView.addView(view: view)
    }
    func setAnimationCompletion(appear:@escaping()->Void,disappear:@escaping()->Void,end:@escaping()->Void){
        self.appearCompletion = appear
        self.disappearCompletion = disappear
        self.endCompletion = end
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var isUp:Bool
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if navigationView.frame.contains(point) || closeButton.frame.contains(point){
            return true
        }else{
            return false
        }
    }
    private func bind(){
        closeButton.rx.tap.withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.dismissAnimation()
        }).disposed(by: disposeBag)
    }
    private func layout(){
        self.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(navigationView)
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationCircleViewTopBegin = navigationView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0.0)
        navigationCircleViewTopBegin.isActive = true
        navigationCircleViewLeadingBegin = navigationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gap)
        navigationCircleViewLeadingBegin.isActive = true
        navigationCircleViewHeightBegin = navigationView.heightAnchor.constraint(equalTo: navigationView.widthAnchor)
        navigationCircleViewHeightBegin.isActive = true
        navigationCircleViewHeightEnd = NSLayoutConstraint(item: navigationView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.8, constant: 0.0)
        navigationCircleViewWidthBegin = NSLayoutConstraint(item: navigationView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.2, constant: 0.0)
        navigationCircleViewWidthBegin.isActive = true
        navigationCircleViewWidthEnd = NSLayoutConstraint(item: navigationView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0.0)
        navigationCircleViewTopEnd = navigationView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        navigationCircleViewLeadingEnd = navigationView.centerXAnchor.constraint(equalTo: centerXAnchor)
        NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.35, constant: 0.0).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: closeButton, attribute: .width, multiplier: 0.35, constant: 0.0).isActive = true
        closeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        closeButtomTopStart = closeButton.topAnchor.constraint(equalTo: self.bottomAnchor)
        closeButtomTopStart.isActive = true
        closeButtonTopEnd = closeButton.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 10.0)
    }
}
extension BackgroundView:GestureDelegate{
    func pangesture(pangesture: Pangesture) {
        switch pangesture.state {
        case .changed,.began:
            let top = navigationCircleViewTopBegin.constant + pangesture.point.y
            let leading = navigationCircleViewLeadingBegin.constant + pangesture.point.x
            navigationCircleViewTopBegin.constant = maxY(top: top)
            navigationCircleViewLeadingBegin.constant = maxX(leading: leading)
        case .ended:
            animate(point: pangesture.point)
        default:
            break;
        }
    }
    func tapGesture() {
        self.isUp = true
        AnimationloginView()
    }
}
extension BackgroundView{
    
    private func maxX(leading:CGFloat)->CGFloat{
        return min(self.frame.maxX-gap-self.navigationView.frame.width, max(leading,gap))
    }
    private func maxY(top:CGFloat)->CGFloat{
        let safeAreaTopBottom = self.safeAreaInsets.bottom+self.safeAreaInsets.top
        let bottomMaxY = self.frame.height-safeAreaTopBottom-self.navigationView.frame.height
        return min(bottomMaxY, max(top,0.0))
    }
    private func animate(point:CGPoint){
        let center = self.navigationCircleViewLeadingBegin.constant+self.navigationView.frame.width/2
        if center <= self.center.x{
            self.navigationCircleViewLeadingBegin.constant = gap
        }else{
            self.navigationCircleViewLeadingBegin.constant = self.frame.maxX - self.navigationView.frame.width-gap
        }
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75,options: .allowUserInteraction, animations: {
            self.layoutIfNeeded()
        })
    }
    func dismissAnimation(){
        disappearCompletion?()
        isUp = false
        navigationView.animationReverse(animationDuration: animationDuration, superviewAnimationBlock: {
            self.animationEnd()
            self.backgroundColor = .clear
            self.alpha = 1.0
            self.layoutIfNeeded()
        },completion: self.endCompletion)
    }
}
extension BackgroundView{
    var animationDuration:CGFloat{
        return 0.65
    }
    private func AnimationloginView(){
        appearCompletion?()
        navigationView.animationWithBasicAnimation(animationDuration: animationDuration, superviewAnimationBlock: {
            self.animationBegan()
            self.backgroundColor = .black.withAlphaComponent(0.75)
            self.layoutIfNeeded()
        },completion: self.endCompletion)
    }

}
extension BackgroundView{
    private func animationBegan(){
        navigationCircleViewWidthBegin.isActive = false
        navigationCircleViewTopBegin.isActive = false
        navigationCircleViewLeadingBegin.isActive = false
        navigationCircleViewHeightBegin.isActive = false
        closeButtomTopStart.isActive = false
        navigationCircleViewWidthEnd.isActive = true
        navigationCircleViewTopEnd.isActive = true
        navigationCircleViewLeadingEnd.isActive = true
        navigationCircleViewHeightEnd.isActive = true
        closeButtonTopEnd.isActive = true
    }
    private func animationEnd(){
        closeButtonTopEnd.isActive = false
        navigationCircleViewWidthEnd.isActive = false
        navigationCircleViewTopEnd.isActive = false
        navigationCircleViewLeadingEnd.isActive = false
        navigationCircleViewHeightEnd.isActive = false
        navigationCircleViewWidthBegin.isActive = true
        navigationCircleViewTopBegin.isActive = true
        navigationCircleViewLeadingBegin.isActive = true
        navigationCircleViewHeightBegin.isActive = true
        closeButtomTopStart.isActive = true
    }
}
