import UIKit
import RxSwift
final class ProductListCollectionView: UICollectionView {
    private let viewModel:ProductListCollectionViewModelInterface
    init(collectionViewLayout layout:ProductListCollectionViewLayout,viewModel:ProductListCollectionViewModelInterface, collectionViewCell cellType:UICollectionViewCell.Type , cellIndentifier indentifier:String) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(cellType, forCellWithReuseIdentifier: indentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CollectionView DEINIT")
    }
    override func reloadItems(at indexPaths: [IndexPath]) {
        for i in 0..<indexPaths.count{
                let cell = self.cellForItem(at: indexPaths[i]) as? AnimationCell
                let price = self.viewModel.returnPrice(index: indexPaths[i])
                cell?.animationObserver.onNext(price)
        }
    }
}
