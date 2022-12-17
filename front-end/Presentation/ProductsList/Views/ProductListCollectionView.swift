import UIKit
final class ProductListCollectionView: UICollectionView {
    init(collectionViewLayout layout:ProductListCollectionViewLayout, collectionViewCell cellType:UICollectionViewCell.Type , cellIndentifier indentifier:String) {

        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(cellType, forCellWithReuseIdentifier: indentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CollectionView DEINIT")
    }
}
