//
//  DetailProductCollectionView.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
final class DetailProductCollectionView:UICollectionView{
    private let viewModel:Pr_DetailProductCollectionViewModel
    private let disposeBag:DisposeBag
    init(viewModel:Pr_DetailProductCollectionViewModel,backgroundColor:UIColor) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(frame: .zero, collectionViewLayout: DetailProductCollectionViewLayout())
        self.register(DetailProductCollectionViewUserCell.self, forCellWithReuseIdentifier: DetailProductCollectionViewUserCell.identifier)
        self.register(DetailProductCollectionViewImageCell.self, forCellWithReuseIdentifier: DetailProductCollectionViewImageCell.identifier)
        self.register(DetailProductCollectionViewCommentCell.self, forCellWithReuseIdentifier: DetailProductCollectionViewCommentCell.identifier)
        self.register(DetailProductCollectionViewGraphCell.self, forCellWithReuseIdentifier: DetailProductCollectionViewGraphCell.identifier)
        bind()
        layout(color: backgroundColor)
    }
    private func layout(color:UIColor){
        self.backgroundColor = .lightGray
        self.contentInsetAdjustmentBehavior = .never
        self.isPrefetchingEnabled = false
    }
    private func bind(){
        self.dataSource = self
        viewModel.dataUpdate.subscribe(onNext: {
            [weak self] _ in
            self?.reloadData()
            self?.layoutIfNeeded()
            if let cell = (self?.cellForItem(at: IndexPath(item: 0, section: 0)) as? DetailProductCollectionViewImageCell){
                let frame = cell.frame
                self?.viewModel.completionReloadDataObserver.onNext(frame)
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DetailProductCollectionView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.returnDetailProductImagesCount() ?? 1
        default:
            return 1
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailProductCollectionViewImageCell.identifier, for: indexPath) as! DetailProductCollectionViewImageCell
            cell.bindingViewModel(cellViewModel: viewModel.returnDetailProductCollectionViewCellViewModel())
            cell.bindingData.onNext(ProductImagesWithTag(product_image: viewModel.returnDetailProductImages(index: indexPath.item), tag: indexPath.item))
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailProductCollectionViewUserCell.identifier, for: indexPath) as! DetailProductCollectionViewUserCell
            cell.bindingViewModel(cellViewModel: viewModel.returnDetailProductCollectionViewUserCellViewModel())
            cell.bindingData.onNext(UserWithTag(user: viewModel.returnDetailProductUser(), tag: indexPath.item))
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailProductCollectionViewCommentCell.identifier, for: indexPath) as! DetailProductCollectionViewCommentCell
            cell.bindingData.onNext(viewModel.returnDetailProductComment())
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailProductCollectionViewGraphCell.identifier, for: indexPath) as! DetailProductCollectionViewGraphCell
            cell.bindingData.onNext(viewModel.returnDetailProductGraph())
            return cell
            
        }
    }
}
