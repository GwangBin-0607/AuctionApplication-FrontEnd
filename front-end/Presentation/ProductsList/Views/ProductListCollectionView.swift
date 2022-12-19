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
    override func reloadItems(at indexPaths: [IndexPath]) {
        UIView.animate(withDuration: 6.0, delay: 0.0, options: .allowUserInteraction, animations: {
            self.performBatchUpdates(nil, completion: nil)
        }, completion: nil)
        for i in 0..<indexPaths.count{
        }
    }
}
protocol animationCell{
    var borderView:UIView{get}
}
