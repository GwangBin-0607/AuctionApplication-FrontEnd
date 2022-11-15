import UIKit
import Foundation
class SomeClass: UIViewController{
    
//    let socket = TCP_Communicator(url: URL(string: "localhost")!, port: 8080)
    let socket = Network()
    let btn = UIButton()
    override func viewDidLoad(){
        self.view.backgroundColor = .white
        self.view.addSubview(btn)
        btn.frame = CGRect(x: 100, y: 100, width: 150, height: 150)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(action), for: .touchUpInside)
//        socket.connect()
        socket.connect(hostName: "ec2-13-125-247-240.ap-northeast-2.compute.amazonaws.com", portNumber: 8100)
//        socket.connect(hostName: "localhost", portNumber: 8100)

     }
    @objc func action(){
//        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        print("Tap")
//        socket.outputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default);
//        socket.inputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default);
//        while(RunLoop.current.run(mode: .default, before: .now+10.0)){
//            print("hello MainThread")
//        }
//        for i in 0..<100{
//            print(i)
//        }
        socket.send(message: "111")
    }
    @objc func timerAction(){
        socket.send(message: "111")

    }
}
