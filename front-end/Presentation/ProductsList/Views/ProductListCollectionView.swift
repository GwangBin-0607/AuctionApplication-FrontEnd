import UIKit
final class ProductListCollectionView: UICollectionView {
    weak var delegateHeight:ReturnImageHeightUICollectionViewDelegate?
    init(collectionViewLayout layout:ProductListCollectionViewLayout, collectionViewCell cellType:UICollectionViewCell.Type , cellIndentifier indentifier:String) {

        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(cellType, forCellWithReuseIdentifier: indentifier)
        layout.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CollectionView DEINIT")
    }
}
extension ProductListCollectionView:ReturnHeightUICollectionViewLayoutDelegate{
    func returnImageHeightFromUICollectionView(index:IndexPath) -> CGFloat {
        delegateHeight!.returnImageHeightFromViewModel(index: index)
    }

}
