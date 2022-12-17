//
//  SceneDelegate.swift
//  front-end
//
//  Created by 안광빈 on 2022/09/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var appCoordinator:AppCoordinator?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let root = MainContainerViewController()
        self.window = window
        self.window?.rootViewController = root
        appCoordinator = AppCoordinator(ContainerViewController: root, SceneDIContainer: SceneDIContainer())
        appCoordinator?.start()
        self.window?.makeKeyAndVisible()
        //NavigationController push는 makeKeyAndVisible전에 가능 present는 안됨
        //UIViewController present는 안댐
        //push는 되는데 present는 안됨.
        //Memory 차이도 있음 navigation push는 root viewcontroller가 없으면 푸시했을때 루트로 만든다
        //.fullscreen으로 하니깐 메모리 작아짐!
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

