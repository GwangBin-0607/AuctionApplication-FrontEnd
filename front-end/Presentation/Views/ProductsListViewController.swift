//
//  ProductListViewController.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductsListViewController: UIViewController {
    
    let viewModel:BindingProductsListViewModel
    let disposeBag = DisposeBag()
    // MARK: - DI
    
    init(viewModel:BindingProductsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        viewModel = ProductsListViewModel(UseCase: ShowProductsListUseCase(FetchingProductsList: FetchingProductsListDataRepository(ApiService: NetworkService())))
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    private func bindingViewModel(){
    
    }
    
}
extension ProductsListViewController{
    override func loadView() {
        super.loadView()
        self.view = setLayout()
        bindingViewModel()
    }
    private func setLayout()->UIView{
        let containerView = UIView()
        containerView.backgroundColor = .white

        return containerView
    }
}

