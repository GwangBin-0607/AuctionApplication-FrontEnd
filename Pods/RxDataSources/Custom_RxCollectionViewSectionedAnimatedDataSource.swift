//
//  Custom_RxCollectionViewSectionedAnimatedDataSource.swift
//  RxDataSources
//
//  Created by 안광빈 on 2023/02/16.
//
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif
import Differentiator
import Foundation
open class Custom_RxCollectionViewSectionedAnimatedDataSource<T:AnimatableSectionModelType>:RxCollectionViewSectionedAnimatedDataSource<T>{
    open override func collectionView(_ collectionView: UICollectionView, observedEvent: Event<RxCollectionViewSectionedAnimatedDataSource<T>.Element>) {
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
                            print(difference.updatedItems)
                            if self?.returnWithOutReload(dif: difference) == true{
                                let updateBlock = {
                                    // sections must be set within updateBlock in 'performBatchUpdates'
                                    dataSource.setSections(difference.finalSections)
                                    collectionView.batchUpdates(difference, animationConfiguration: dataSource.animationConfiguration)
                                }
                                
                                collectionView.performBatchUpdates(updateBlock, completion: nil)
                            }else if let index = self?.returnReloadIndexPath(dif: difference){
                                collectionView.reloadItems(at: index)
//                                collectionView.animationItem(idx: index)
                                dataSource.setSections(difference.finalSections)
                            }
                        }
                        
                    case .reload:
                        dataSource.setSections(newSections)
                        collectionView.reloadData()
                        return
                    }
                }
                catch let e {
                    rxDebugFatalError(e)
                    dataSource.setSections(newSections)
                    collectionView.reloadData()
                }
            }
        }.on(observedEvent)
    }
    private func returnWithOutReload<T:AnimatableSectionModelType>(dif:Changeset<T>)->Bool{
        dif.insertedItems.isEmpty ? false : true
    }
    
    private func returnReloadIndexPath<T:AnimatableSectionModelType>(dif:Changeset<T>)->[IndexPath]{
        var arrayIdx:[IndexPath] = []
        dif.updatedItems.forEach { itemPath in
            arrayIdx.append(IndexPath(item: itemPath.itemIndex, section: itemPath.sectionIndex))
        }
        return arrayIdx
        
    }
}
