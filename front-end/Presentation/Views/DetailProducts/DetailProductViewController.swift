//
//  DetailProductViewController.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/24.
//

import Foundation
import UIKit

class DetailProductViewController:UIViewController,SetCoordinatorViewController{
    let delegate:TransitionDetailProductViewController?
    let backBtn = UIButton()
    init(transitioning:TransitionDetailProductViewController?=nil) {
        self.delegate = transitioning
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        let view = UIView()
        view.backgroundColor = .systemPink
        view.addSubview(backBtn)
        backBtn.backgroundColor = .yellow
        backBtn.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        backBtn.addTarget(self, action: #selector(action), for: .touchUpInside)
        self.view = view
    }
    @objc func action(){
        delegate?.dismissToProductListView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1111")
        print(self.parent)
    }
}
