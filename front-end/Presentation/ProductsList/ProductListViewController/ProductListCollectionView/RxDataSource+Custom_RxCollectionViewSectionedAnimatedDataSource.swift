#if os(iOS) || os(tvOS)
import Foundation
import UIKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif
import Differentiator
import RxDataSources
class Custom_RxCollectionViewSectionedAnimatedDataSource<Section: AnimatableSectionModelType>: CollectionViewSectionedDataSource<Section>
, RxCollectionViewDataSourceType{
    public typealias Element = [Section]
    public typealias DecideViewTransition = (CollectionViewSectionedDataSource<Section>, UICollectionView, [Changeset<Section>]) -> ViewTransition

    // animation configuration
    public var animationConfiguration: AnimationConfiguration

    /// Calculates view transition depending on type of changes
    public var decideViewTransition: DecideViewTransition

    public init(
        animationConfiguration: AnimationConfiguration = AnimationConfiguration(),
        decideViewTransition: @escaping DecideViewTransition = { _, _, _ in .animated },
        configureCell: @escaping ConfigureCell,
        configureSupplementaryView: ConfigureSupplementaryView? = nil,
        moveItem: @escaping MoveItem = { _, _, _ in () },
        canMoveItemAtIndexPath: @escaping CanMoveItemAtIndexPath = { _, _ in false }
        ) {
        self.animationConfiguration = animationConfiguration
        self.decideViewTransition = decideViewTransition
        super.init(
            configureCell: configureCell,
            configureSupplementaryView: configureSupplementaryView,
            moveItem: moveItem,
            canMoveItemAtIndexPath: canMoveItemAtIndexPath
        )
    }
    
    // there is no longer limitation to load initial sections with reloadData
    // but it is kept as a feature everyone got used to
    var dataSet = false

    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<RxCollectionViewSectionedAnimatedDataSource<Section>.Element>) {
        Binder(self) {
            [weak self] dataSource, newSections in
            #if DEBUG
                dataSource._dataSourceBound = true
            #endif
            if !dataSource.dataSet {
                dataSource.dataSet = true
                dataSource.setSections(newSections)
                collectionView.reloadData()
            }
            else {
                // if view is not in view hierarchy, performing batch updates will crash the app
                if collectionView.window == nil {
                    dataSource.setSections(newSections)
                    collectionView.reloadData()
                    return
                }
                let oldSections = dataSource.sectionModels
                do {
                    let differences = try Diff.differencesForSectionedView(initialSections: oldSections, finalSections: newSections)
                    
                    switch dataSource.decideViewTransition(dataSource, collectionView, differences) {
                    case .animated:
                        // each difference must be run in a separate 'performBatchUpdates', otherwise it crashes.
                        // this is a limitation of Diff tool
                        for difference in differences {
                            if self?.returnWithOutReload(dif: difference) == true{
                                let updateBlock = {
                                    // sections must be set within updateBlock in 'performBatchUpdates'
                                    dataSource.setSections(difference.finalSections)
                                    collectionView.batchUpdates(difference, animationConfiguration: dataSource.animationConfiguration)
                                }
                                
                                collectionView.performBatchUpdates(updateBlock, completion: nil)
                            }else if let index = self?.returnReloadIndexPath(dif: difference){
                                collectionView.reloadItems(at: index)
                                dataSource.setSections(difference.finalSections)
                            }
                        }
                        
                    case .reload:
                        dataSource.setSections(newSections)
                        collectionView.reloadData()
                        return
                    }
                }
                catch {
                    dataSource.setSections(newSections)
                    collectionView.reloadData()
                }
            }
        }.on(observedEvent)
    }
    private func returnWithOutReload<T:AnimatableSectionModelType>(dif:Changeset<T>)->Bool{
        dif.insertedItems.isEmpty && dif.deletedItems.isEmpty && dif.movedItems.isEmpty ? false : true
    }
    
    private func returnReloadIndexPath<T:AnimatableSectionModelType>(dif:Changeset<T>)->[IndexPath]{
        var arrayIdx:[IndexPath] = []
        dif.updatedItems.forEach { itemPath in
            arrayIdx.append(IndexPath(item: itemPath.itemIndex, section: itemPath.sectionIndex))
        }
        return arrayIdx
        
    }
    
    
}
#endif
