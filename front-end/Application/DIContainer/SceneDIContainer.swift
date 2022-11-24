import Foundation

class SceneDIContainer{
    private func returnShowProductListUseCase()->ShowProductsListUseCase{
        ShowProductsListUseCase(ProductsListRepository: returnProductsListRepository(), ProductPriceRepository: returnProductPriceRepository())
    }
    private func returnProductsListRepository()->FetchingProductsListData{
        ProductsListRepository(ApiService: returnHTTPService())
    }
    private func returnHTTPService()->GetProductsList{
        ProductsListHTTP(ServerURL: "11111")
    }
    private func returnProductPriceRepository()->TransferProductPriceDataInput&ObserverSocketState{
        ProductPriceRepository(StreamingService: returnStreamingService())
    }
    private func returnStreamingService()->StreamingData{
        SocketNetwork(hostName: "localhost", portNumber: 8100)
    }
}
