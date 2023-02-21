import UIKit
final class BuyProductButton:UIButton{
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
    init(title:String,horizontalPadding:CGFloat) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = .red
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.tintColor = .gray
        if #available(iOS 15.0, *){
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontalPadding, bottom: 0, trailing: horizontalPadding)
            self.configuration = config
        }else{
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
