//
//  ManageColor.swift
//  front-end
//
//  Created by 안광빈 on 2023/02/17.
//

import UIKit

class ManageColor{
    static let singleton = ManageColor(mainColor: .systemYellow)
    private let mainColor:UIColor
    private init(mainColor:UIColor) {
        self.mainColor = mainColor
    }
    func getMainColor()->UIColor{
        mainColor
    }
}
