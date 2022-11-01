//
//  ProductsListCellTableViewCell.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import UIKit

class ProductsListTableViewCell: UITableViewCell {
    let name = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        name.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        name.backgroundColor = .red
        name.text = "Hello"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
