import UIKit
import RxSwift
final class BuyProductButton:UIButton{
    private let startColor:UIColor
    private let endColor:UIColor
    private let viewModel:Pr_BuyProductButtonViewModel
    private let disposeBag:DisposeBag
    override var intrinsicContentSize: CGSize{
        let original = super.intrinsicContentSize
        if #available(iOS 15.0, *){
            if let configuration = configuration{
                return CGSize(width:original.width+configuration.contentInsets.leading+configuration.contentInsets.trailing , height: original.height)

            }else{
                return original
            }
        }else{
            return CGSize(width:original.width+contentEdgeInsets.left+contentEdgeInsets.right , height: original.height)
        }
    }
    init(viewModel:Pr_BuyProductButtonViewModel) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        startColor = .white
        endColor = .white
        super.init(frame: .zero)
        bind()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = endColor
        self.setTitle("구매하기", for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.contentMode = .scaleAspectFit
        self.tintColor = .gray
        let horizontalPadding:CGFloat = 5
        if #available(iOS 15.0, *){
            var config = UIButton.Configuration.plain()
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
               var outgoing = incoming
               outgoing.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
               return outgoing
            }
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontalPadding, bottom: 0, trailing: horizontalPadding)
            self.configuration = config
        }else{
            self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        }
    }
    private func bind(){
        rx.tap.bind(to: viewModel.tapObserver).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
