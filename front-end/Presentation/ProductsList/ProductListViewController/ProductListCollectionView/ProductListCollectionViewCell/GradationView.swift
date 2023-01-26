//
//  GradationView.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/27.
//

import Foundation
import UIKit
final class GradationView:UIView{
    let gradationLayer:CAGradientLayer
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradationLayer.frame = rect
    }
    init(){
        gradationLayer = CAGradientLayer()
        gradationLayer.colors = [UIColor.darkGray.withAlphaComponent(0.7).cgColor,UIColor.systemGroupedBackground.withAlphaComponent(0.5).cgColor]
        gradationLayer.locations = [0.5 , 1.0]
        gradationLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradationLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        super.init(frame: .zero)
        self.layer.addSublayer(gradationLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
