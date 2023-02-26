//
//  DetailProductCollectionViewLayout.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
import UIKit
final class DetailProductCollectionViewLayout:UICollectionViewCompositionalLayout{
    private class DecoBlackView:UICollectionReusableView{
        static let identifier = "background-black-decoration"
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .darkGray
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    private class DecoGrayView:UICollectionReusableView{
        static let identifier = "background-systemgray-decoration"
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .systemGray6
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    let provider:UICollectionViewCompositionalLayoutSectionProvider = {
        section,env in
        switch section{
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: DecoGrayView.identifier)
            section.decorationItems = [sectionBackground]
            return section
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100.0)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: DecoBlackView.identifier)
            section.decorationItems = [sectionBackground]
            section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0)
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: DecoBlackView.identifier)
            section.decorationItems = [sectionBackground]
            section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0)
            return section
        case 3:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        default :
            return nil
            
        }
    }
    init() {
        super.init(sectionProvider: provider)
        self.register(DecoGrayView.self, forDecorationViewOfKind: DecoGrayView.identifier)
        self.register(DecoBlackView.self, forDecorationViewOfKind: DecoBlackView.identifier)
    }
    private var imageSectionWidth:CGFloat?
    override func prepare() {
        super.prepare()
        if let col = collectionView{
            imageSectionWidth = CGFloat(col.numberOfItems(inSection: 0)) * col.frame.width
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    private var headerViewHeight:CGFloat?
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let imageSectionWidth = imageSectionWidth else{
            return nil
        }
        let reRect = CGRect(x: rect.minX, y: rect.minY, width: imageSectionWidth, height: rect.height)
        let layoutAttributes = super.layoutAttributesForElements(in: reRect)
        layoutAttributes?.forEach { attribute in
            if attribute.indexPath.section == 0 {
                guard let collectionView = collectionView else { return }
                let contentOffsetY = collectionView.contentOffset.y
                if headerViewHeight == nil{
                    headerViewHeight = attribute.frame.height
                }
                if contentOffsetY <= 0,let height = headerViewHeight {
                    let width = collectionView.frame.width - contentOffsetY
                    let height = height - contentOffsetY
                    let minx = contentOffsetY/2.0
                    let index = CGFloat(attribute.indexPath.item)*collectionView.frame.width
                    attribute.frame = CGRect(x: index+minx, y: contentOffsetY, width: width, height: height)
                }
            }
        }
        return layoutAttributes
    }
}
