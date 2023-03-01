//
//  EnablePriceLabel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/27.
//

import Foundation

final class EnablePriceLabel:PriceLabel{
    override init(viewModel: Pr_DetailPriceLabelViewModel) {
        super.init(viewModel: viewModel)
        numberOfLines = 2
        self.textAlignment = .center
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
