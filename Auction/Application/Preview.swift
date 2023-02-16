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
struct VCPreView:PreviewProvider{
    static var previews: some View{
        let vC = TestViewController()
        return vC.toPreview()
    }
}
class TestViewController:UIViewController{
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .red
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
