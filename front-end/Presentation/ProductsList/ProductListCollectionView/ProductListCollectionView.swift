import UIKit
import RxSwift
import RxDataSources
final class ProductListCollectionView: UICollectionView {
    private let viewModel:Pr_Out_ProductListCollectionViewModel
    private let disposeBag:DisposeBag
    init(collectionViewLayout layout:ProductListCollectionViewLayout,viewModel:Pr_Out_ProductListCollectionViewModel, collectionViewCell cellType:UICollectionViewCell.Type , cellIndentifier indentifier:String) {
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(cellType, forCellWithReuseIdentifier: indentifier)
        self.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.Identifier)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind(){
        viewModel.productsList.bind(to: self.rx.items(dataSource: returnDataSource())).disposed(by: disposeBag)
        self.rx.willDisplaySupplementaryView.subscribe(onNext: {
            a,b,c in
            self.viewModel.requestProductsList.onNext(())
        }).disposed(by: disposeBag)
//        self.rx.willDisplayCell.subscribe(onNext: {
//            cel,inx in
//            if inx.item == 11{
//                self.viewModel.requestProductsList.onNext(())
//                print("11")
//            }
//        }).disposed(by: disposeBag)
    }
    
    deinit {
        print("CollectionView DEINIT")
    }
    override func reloadItems(at indexPaths: [IndexPath]) {
        for i in 0..<indexPaths.count{
            if let cell = self.cellForItem(at: indexPaths[i]) as? AnimationCell{
                let price = self.viewModel.returnPrice(index: indexPaths[i])
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
        }, configureCell: { [weak self] _ , colview, indexpath, item in
            let cell = colview.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.Identifier, for: indexpath) as! ProductListCollectionViewCell
            cell.bindingViewModel(cellViewModel:self?.viewModel.returnCellViewModel())
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
