//
//  ProductListCollectionView.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/03.
//

import UIKit

class ProductListCollectionView: UICollectionView {
    init(collectionViewLayout layout:UICollectionViewLayout, collectionViewCell cellType:UICollectionViewCell.Type , cellIndentifier indentifier:String) {
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(cellType, forCellWithReuseIdentifier: indentifier)
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
