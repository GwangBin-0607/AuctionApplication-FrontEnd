//
//  DetailProductCollectionViewLayout.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
import UIKit
final class DetailProductCollectionViewLayoutContext:UICollectionViewLayoutInvalidationContext{
    var section:Bool?
}
final class DetailProductCollectionViewLayout:UICollectionViewCompositionalLayout{
    override class var invalidationContextClass: AnyClass{
        DetailProductCollectionViewLayoutContext.self
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
            return section
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
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
        if let c = self.invalidationContext(forBoundsChange: newBounds) as? DetailProductCollectionViewLayoutContext,let check = c.section{
            print(check)
            return check
        }else{
            return false
        }
    }
    private var headerViewHeight:CGFloat?
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let imageSectionWidth = imageSectionWidth else{
            return nil
        }
        print(self.collectionView?.contentOffset.x)
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
                    let minx = contentOffsetY/2
                    let index = CGFloat(attribute.indexPath.item)*collectionView.frame.width
                    print(attribute.indexPath)
                    attribute.frame = CGRect(x: index+minx, y: contentOffsetY, width: width, height: height)
                }
            }
        }
        return layoutAttributes
    }
    override func invalidateLayout() {
        super.invalidateLayout()
        print("INVALIDATE")
    }
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        if let c = super.invalidationContext(forBoundsChange: newBounds) as? DetailProductCollectionViewLayoutContext{
            c.section = newBounds.contains(CGPoint(x: 0, y: 400)) ? true : false
            return c
        }else{
            return super.invalidationContext(forBoundsChange: newBounds)
        }
    }
}
