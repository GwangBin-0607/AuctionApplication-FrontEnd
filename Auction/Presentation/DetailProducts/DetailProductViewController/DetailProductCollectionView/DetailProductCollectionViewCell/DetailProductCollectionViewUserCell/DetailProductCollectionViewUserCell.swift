import UIKit
import RxSwift
final class DetailProductCollectionViewUserCell:UICollectionViewCell{
    let label = UILabel()
    let bindingData:AnyObserver<DetailProductUser?>
    static let identifier = "DetailProductCollectionViewCell"
    override init(frame: CGRect) {
        let bindingSubject = PublishSubject<DetailProductUser?>()
        bindingData = bindingSubject.asObserver()
        super.init(frame: frame)
        layout()
    }
    private func layout(){
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.contentView.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
