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
    private let profileImageView:ProfileImageView
    private let nicknameLabel:UILabel
    private let disposeBag:DisposeBag
    private let idTextField:UITextField
    private let loginButton:CustomTextButton
    private var viewUp:Bool
    private var login:LoginState
    init(ViewModel:Pr_NavigationCircleViewModel,customTextButton:CustomTextButton) {
        idTextField = UITextField()
        loginButton = customTextButton
        login = .logout
        viewUp = false
        disposeBag = DisposeBag()
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
        loginDownNSConstraints = initLoginDownNSConstraints()
        loginUpNSConstraints = initLoginUpNSConstraints()
        logoutUpNSConstraints = initLogoutUpNSConstraints()
        logoutDownNSConstraints = initLogoutDownNSConstraints()
        layout()
        bind()
    }
    private func bind(){
        viewModel.loginStateObservable.withUnretained(self).subscribe(onNext: {
            owner,state in
            owner.layoutLoginConstraints(before: owner.login, after: state)
        }).disposed(by: disposeBag)
        
        viewModel.backGestureObservable.withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.viewUp = false
            owner.animationReverser(animation: owner.alphaAnimation, reverse: true)
            owner.layoutConstraints()
        }).disposed(by: disposeBag)
    }
    private func layoutConstraints(){
        switch (login,viewUp) {
        case (.login,false):
            loginUpNSContraintsInActive()
            loginDownNSContraintsActive()
        case (.login,true):
            loginDownNSContraintsInActive()
            loginUpNSContraintsActive()
        case (.logout,false):
            logoutUpNSContraintsInActive()
            logoutDownNSContraintsActive()
        case (.logout,true):
            logoutDownNSContraintsInActive()
            logoutUpNSContraintsActive()
        }
    }
    private func layoutLoginConstraints(before: LoginState,after:LoginState){
        if before == after{
            layoutConstraints()
        }else{
            switch (before,after,viewUp) {
            case (.login,.logout,true):
                loginUpNSContraintsInActive()
                logoutUpNSContraintsActive()
            case (.logout,.login,true):
                logoutUpNSContraintsInActive()
                loginUpNSContraintsActive()
            case (.login,.logout,false):
                loginDownNSContraintsInActive()
                logoutDownNSContraintsActive()
            case (.logout,.login,false):
                logoutDownNSContraintsInActive()
                loginDownNSContraintsActive()
            default:
                break;
            }
            UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
                self.layoutIfNeeded()
            })
            login = after
        }
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
    private var loginUpNSConstraints:[NSLayoutConstraint] = []
    private var loginDownNSConstraints:[NSLayoutConstraint] = []
    private var logoutUpNSConstraints:[NSLayoutConstraint] = []
    private var logoutDownNSConstraints:[NSLayoutConstraint] = []
    private func layout(){
        self.addSubview(nicknameLabel)
        self.addSubview(profileImageView)
        self.addSubview(idTextField)
        self.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        nicknameLabel.contentMode = .center
        nicknameLabel.textAlignment = .center
        profileImageView.backgroundColor = .blue
        nicknameLabel.backgroundColor = .yellow
        idTextField.backgroundColor = .red
        nicknameLabel.text = "로그인을 해주세요"
        nicknameLabel.numberOfLines = 2
        nicknameLabel.adjustsFontSizeToFitWidth = true
        nicknameLabel.minimumScaleFactor = 0.2
        loginButton.setTitle("LOGIN", for: .normal)
        
    }
}
extension NavigationCornerRadiusView{
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewUp = true
        layoutConstraints()
        viewModel.tapGestureObserver.onNext(())
        animationReverser(animation: alphaAnimation, reverse: false)
    }
    private func animationReverser(animation:UIViewPropertyAnimator,reverse:Bool){
        animation.isReversed = reverse
        animation.startAnimation()
    }
}
extension NavigationCornerRadiusView{
    private func initLoginDownNSConstraints()->[NSLayoutConstraint]{
        var constraints:[NSLayoutConstraint] = []
        let profileTop = profileImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 5.0)
        let profileLeading = profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let profileWidth = NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.6, constant: 0.0)
        let profileHeight = NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: profileImageView, attribute: .height, multiplier: 1.0, constant: 0.0)
        let nicknameLeading = nicknameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5.0)
        let nicknameTrailing = nicknameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5.0)
        let nicknameTop = nicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5.0)
        let nicknameBottom = nicknameLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -5.0)
        let idtextTop = idTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor,constant: 5.0)
        let idtextLeading = idTextField.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5.0)
        let loginButtonTop = loginButton.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 5.0)
        let loginButtonLeading = loginButton.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5.0)
        constraints.append(profileTop)
        constraints.append(profileLeading)
        constraints.append(profileWidth)
        constraints.append(profileHeight)
        constraints.append(nicknameTop)
        constraints.append(nicknameLeading)
        constraints.append(nicknameTrailing)
        constraints.append(nicknameBottom)
        constraints.append(idtextTop)
        constraints.append(idtextLeading)
        constraints.append(loginButtonTop)
        constraints.append(loginButtonLeading)
        return constraints
    }
    private func loginDownNSContraintsActive(){
        loginDownNSConstraints.forEach({$0.isActive = true})
    }
    private func loginDownNSContraintsInActive(){
        loginDownNSConstraints.forEach({$0.isActive = false})
    }
}
extension NavigationCornerRadiusView{
    private func initLoginUpNSConstraints()->[NSLayoutConstraint]{
        var constraints:[NSLayoutConstraint] = []
        let profileTop = NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.2, constant: 0.0)
        let profileLeading = profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5.0)
        let profileWidth = NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.2, constant: 0.0)
        let profileHeight = NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: profileImageView, attribute: .height, multiplier: 1.0, constant: 0.0)
        let nicknameLeading = nicknameLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor,constant: 5.0)
        let nicknameTrailing = nicknameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5.0)
        let nicknameTop = nicknameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        let idtextTop = idTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor,constant: 5.0)
        let idtextLeading = idTextField.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5.0)
        let loginButtonTop = loginButton.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 5.0)
        let loginButtonLeading = loginButton.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5.0)
        constraints.append(profileTop)
        constraints.append(profileLeading)
        constraints.append(profileWidth)
        constraints.append(profileHeight)
        constraints.append(nicknameTop)
        constraints.append(nicknameLeading)
        constraints.append(nicknameTrailing)
        constraints.append(idtextTop)
        constraints.append(idtextLeading)
        constraints.append(loginButtonTop)
        constraints.append(loginButtonLeading)
        return constraints
    }
    private func loginUpNSContraintsActive(){
        loginUpNSConstraints.forEach({$0.isActive = true})
    }
    private func loginUpNSContraintsInActive(){
        loginUpNSConstraints.forEach({$0.isActive = false})
    }
}
extension NavigationCornerRadiusView{
    private func initLogoutDownNSConstraints()->[NSLayoutConstraint]{
        var constraints:[NSLayoutConstraint] = []
        let nicknameLeading = nicknameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5.0)
        let nicknameTrailing = nicknameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5.0)
        let nicknameTop = nicknameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let idTop = idTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 5.0)
        let idLeading = idTextField.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5.0)
        let buttonTop = loginButton.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 5.0)
        let buttonLeading = loginButton.leadingAnchor.constraint(equalTo: self.trailingAnchor,constant: 5.0)
        constraints.append(nicknameTop)
        constraints.append(nicknameLeading)
        constraints.append(nicknameTrailing)
        constraints.append(idTop)
        constraints.append(idLeading)
        constraints.append(buttonTop)
        constraints.append(buttonLeading)
        return constraints
    }
    private func logoutDownNSContraintsActive(){
        logoutDownNSConstraints.forEach({$0.isActive = true})
    }
    private func logoutDownNSContraintsInActive(){
        logoutDownNSConstraints.forEach({$0.isActive = false})
    }
}
extension NavigationCornerRadiusView{
    private func initLogoutUpNSConstraints()->[NSLayoutConstraint]{
        var constraints:[NSLayoutConstraint] = []
        let nicknameLeading = nicknameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5.0)
        let nicknameTrailing = nicknameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5.0)
        let nicknameTop = NSLayoutConstraint(item: nicknameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.5, constant: 0.0)
        let idTop = idTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 5.0)
        let idLeading = idTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0)
        let idTrailing = idTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5.0)
        let idHeight = NSLayoutConstraint(item: idTextField, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.15, constant: 0.0)
        let buttonTop = loginButton.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 5.0)
        let buttonLeading = loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5.0)
        let buttonTrailing = loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0)
        constraints.append(nicknameTop)
        constraints.append(nicknameLeading)
        constraints.append(nicknameTrailing)
        constraints.append(idTop)
        constraints.append(idLeading)
        constraints.append(idTrailing)
        constraints.append(idHeight)
        constraints.append(buttonTop)
        constraints.append(buttonLeading)
        constraints.append(buttonTrailing)
        return constraints
    }
    private func logoutUpNSContraintsActive(){
        logoutUpNSConstraints.forEach({$0.isActive = true})
    }
    private func logoutUpNSContraintsInActive(){
        logoutUpNSConstraints.forEach({$0.isActive = false})
    }
}
