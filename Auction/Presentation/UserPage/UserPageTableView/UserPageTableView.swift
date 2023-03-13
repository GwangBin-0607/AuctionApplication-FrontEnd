//
//  UserPageTableView.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import UIKit
import RxSwift
final class UserPageTableView:UITableView{
    private let viewModel:Pr_UserPageTableViewModel
    private let disposeBag:DisposeBag
    init(viewModel:Pr_UserPageTableViewModel) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(frame: .zero, style: .plain)
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 100
        self.register(UserPageTableViewCell.self, forCellReuseIdentifier: UserPageTableViewCell.IDENTIFIER)
        bind()
        viewModel.reloadTableView.onNext(())
    }
    private func bind(){
        viewModel.tableViewContent.bind(to: rx.items){
            tbl,index,elements in
            print("CELL")
            let cell = tbl.dequeueReusableCell(withIdentifier: UserPageTableViewCell.IDENTIFIER) as? UserPageTableViewCell
            cell?.binding.onNext(elements)
            return cell ?? UITableViewCell()
        }.disposed(by: disposeBag)
        rx.itemSelected.withUnretained(self).subscribe(onNext: {
            owner,idx in
            if idx.item == 0{
                owner.viewModel.loginPresentObserver.onNext(())
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
