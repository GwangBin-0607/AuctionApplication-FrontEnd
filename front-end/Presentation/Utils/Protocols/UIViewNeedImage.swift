import UIKit
import RxSwift
struct RequestImage{
    private let cell:NeedImageCell
    private let productId:Int
    private let imageURL:String?
    private let rowNum:Int
    init(Cell:NeedImageCell,ProductId:Int,ImageURL:String?,RowNum:Int) {
        self.cell = Cell
        self.productId = ProductId
        self.imageURL = ImageURL
        self.rowNum = RowNum
    }
    func returnCell()->NeedImageCell{
        cell
    }
    func returnProductId()->Int{
        productId
    }
    func returnImageURL()->String?{
        imageURL
    }
    func returnRowNum()->Int{
        rowNum
    }
}
struct ResponseImage{
    private let cell:NeedImageCell
    private let image:UIImage
    private let rowNum:Int
    init(Cell:NeedImageCell,Image:UIImage,RowNum:Int) {
        self.cell = Cell
        self.image = Image
        self.rowNum = RowNum
    }
    func returnRowNum()->Int{
        rowNum
    }
    func returnImage()->UIImage{
        image
    }
    func setImageToCell(){
        cell.imageBinding.onNext(self)
    }
}
protocol NeedImageCell:AnyObject{
    var imageBinding:AnyObserver<ResponseImage>{get}
}
