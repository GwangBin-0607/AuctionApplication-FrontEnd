import UIKit
import RxSwift
import RxDataSources
protocol ReturnDataSource:UICollectionView{
    func returnDataSource()->RxCollectionViewSectionedAnimatedDataSource<ProductSection>
}
final class ProductListCollectionView: UICollectionView,ReturnDataSource {
    private let returnPriceDelegate:ReturnPriceWhenReloadCellInterface
    init(collectionViewLayout layout:ProductListCollectionViewLayout,delegate:ReturnPriceWhenReloadCellInterface, collectionViewCell cellType:UICollectionViewCell.Type , cellIndentifier indentifier:String) {
        self.returnPriceDelegate = delegate
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(cellType, forCellWithReuseIdentifier: indentifier)
        self.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.Identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CollectionView DEINIT")
    }
    override func reloadItems(at indexPaths: [IndexPath]) {
        for i in 0..<indexPaths.count{
            if let cell = self.cellForItem(at: indexPaths[i]) as? AnimationCell{
                let price = self.returnPriceDelegate.returnPrice(index: indexPaths[i])
                cell.animationObserver.onNext(price)
            }
        }
    }
}
extension ProductListCollectionView{
    func returnDataSource()->RxCollectionViewSectionedAnimatedDataSource<ProductSection>{
        return RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .left, deleteAnimation: .fade), decideViewTransition: {
            _,_,change in
            return .animated
        }, configureCell: { _ , colview, indexpath, item in
            let cell = colview.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.Identifier, for: indexpath) as! ProductListCollectionViewCell
            cell.bindingData.onNext(item)
            return cell
        },configureSupplementaryView: {
            ds, colview, headerOrFooter, indexPath in
            if headerOrFooter == UICollectionView.elementKindSectionFooter{
                let footer = colview.dequeueReusableSupplementaryView(ofKind: headerOrFooter, withReuseIdentifier: FooterView.Identifier, for: indexPath)
                return footer
            }else{
                fatalError("NONO")
            }
            
        })
    }
}
class FooterView:UICollectionReusableView{
    static let Identifier:String = "FooterView"
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
