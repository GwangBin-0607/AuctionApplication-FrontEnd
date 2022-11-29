//
//  ProductListViewController.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa
final class ProductListViewController: UIViewController,SetCoordinatorViewController {
    private let viewModel:BindingProductsListViewModel
    private let disposeBag:DisposeBag
    private let collectionView:UICollectionView
    private let categoryView:UIView
    let testBtn:UIButton
    let testUseCase:ProductPriceRepository
    let delegate:TransitionPresentViewController?
    init(viewModel:BindingProductsListViewModel,CollectionView:UICollectionView,transitioning:TransitionPresentViewController?=nil) {
        self.delegate = transitioning
        self.viewModel = viewModel
        collectionView = CollectionView
        disposeBag = DisposeBag()
        categoryView = UIView()
        testBtn = UIButton()
        testUseCase = ProductPriceRepository(StreamingService: SocketNetwork(hostName: "localhost", portNumber: 8100))
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        testUse()
    }
    func testUse(){
        testUseCase.streamState(state: .connect)
    }

    private func bindingViewModel(){
        testBtn.rx.tap.subscribe(onNext: {
            [weak self] in
            print("Tap")
            print(self?.delegate)
            self?.delegate?.presentViewController()
//            self?.present(pre, animated: true, completion: nil)
//            self?.testUseCase.transferPriceToData(output: StreamPrice(id: 1000, price: 1111000))
//            self?.viewModel.requestProductsList.onNext(1)
        }).disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.productsList.bind(to: collectionView.rx.items(cellIdentifier: ProductListCollectionViewCell.Identifier, cellType: ProductListCollectionViewCell.self)){
            _,item, cell in
            cell.bindingData.onNext(item)
        }.disposed(by: disposeBag)
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ProductListViewController{
    override func loadView() {
        super.loadView()
        self.view = setLayout()
    }
    private func setLayout()->UIView{
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.addSubview(categoryView)
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.backgroundColor = .red
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .yellow
        containerView.addSubview(testBtn)
        testBtn.frame = CGRect(x: 250, y: 450, width:  150, height: 150)
        testBtn.backgroundColor = .green
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            NSLayoutConstraint(item: categoryView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 0.08, constant: 0.0),
            collectionView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
        ])
        return containerView
    }
}
extension ProductListViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3-2, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        2.0
    }
}
