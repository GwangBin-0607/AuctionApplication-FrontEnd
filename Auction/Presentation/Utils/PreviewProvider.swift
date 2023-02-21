import SwiftUI

#if DEBUG_LOCALSERVER || DEBUG_LOCALSERVER_DOCKER || DEBUG_REMOTESERVER
extension UIViewController{
    private struct Preview:UIViewControllerRepresentable{
        let viewController:UIViewController
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
    }
    func toPreview() -> some View{
        Preview(viewController:self)
    }
}
//struct VCPreView:PreviewProvider{
//    static var previews: some View{
//        let sceneDIContaier = SceneDIContainer()
//        let vC = DetailProductViewController()
//        return vC.toPreview().ignoresSafeArea()
//    }
//}
#endif
