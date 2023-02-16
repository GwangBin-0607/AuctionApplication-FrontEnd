import UIKit
import RxSwift
import RxDataSources
final class ProductListCollectionView: UICollectionView {
    private let viewModel:Pr_ProductListCollectionViewModel
    private let disposeBag:DisposeBag
    private var isScrolling:Bool = false
    init(collectionViewLayout layout:ProductListCollectionViewLayout,viewModel:Pr_ProductListCollectionViewModel) {
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: layout)
        self.backgroundColor = .black
        self.register(ProductListCollectionViewCell.self, forCellWithReuseIdentifier: ProductListCollectionViewCell.Identifier)
        self.register(ProductListCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ProductListCollectionFooterView.Identifier)
        bind()
        print("\(String(describing: self)) INIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind(){
        viewModel.requestProductsList.onNext(())
        viewModel.productsList.bind(to: rx.items(dataSource: returnDataSource())).disposed(by: disposeBag)
        self.rx.willDisplaySupplementaryView.subscribe(onNext: {
            [weak self] _,_,_ in
            self?.viewModel.requestProductsList.onNext(())
        }).disposed(by: disposeBag)
        self.rx.itemSelected.subscribe(onNext: {
            [weak self] idx in
            self?.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }).disposed(by: disposeBag)
        self.rx.willBeginDragging.subscribe(onNext: {
            [weak self] in
            self?.isScrolling = true
        }).disposed(by: disposeBag)
        self.rx.didEndDecelerating.subscribe(onNext: {
            [weak self] in
            self?.isScrolling = false
        }).disposed(by: disposeBag)
        self.rx.didEndDragging.subscribe(onNext: {
            [weak self] check in
            self?.isScrolling = check
        }).disposed(by: disposeBag)
    }
    
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    override func reloadItems(at indexPaths: [IndexPath]) {
        if !isScrolling{
            for i in 0..<indexPaths.count{
                if let cell = self.cellForItem(at: indexPaths[i]) as? ProductListCollectionViewCell,self.visibleCells.contains(cell){
                    let animationValue = self.viewModel.returnAnimationValue(index: indexPaths[i])
                    cell.animationObserver.onNext(animationValue)
                }
            }
        }
    }
}
extension ProductListCollectionView{
    func returnDataSource()->Custom_RxCollectionViewSectionedAnimatedDataSource<ProductSection>{
        return Custom_RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .left, deleteAnimation: .fade), decideViewTransition: {
            _,_,change in
            return .animated
        }, configureCell: { [weak self] _ , colview, indexpath, item in
            let cell = colview.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.Identifier, for: indexpath) as! ProductListCollectionViewCell
            cell.bindingViewModel(cellViewModel:self?.viewModel.returnCellViewModel())
            cell.bindingData.onNext(item)
            return cell
        },configureSupplementaryView: {
            [weak self] ds, colview, headerOrFooter, indexPath in
            if headerOrFooter == UICollectionView.elementKindSectionFooter{
                let footer = colview.dequeueReusableSupplementaryView(ofKind: headerOrFooter, withReuseIdentifier: ProductListCollectionFooterView.Identifier, for: indexPath) as? ProductListCollectionFooterView
                footer?.bindingViewModel(FooterViewModel: self?.viewModel.returnFooterViewModel())
                return footer ?? UICollectionReusableView()
            }else{
                fatalError("NONO")
            }
            
        })
    }
}
